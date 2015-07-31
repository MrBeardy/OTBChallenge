require 'spec_helper'

describe QQ do
  it 'should return a blank string' do
    qq = QQ.new

    expect( qq.run ).to eq ''
  end

  it 'should return a single job' do
    qq = QQ.new ' a => '

    expect( qq.run ).to eq 'a'
  end

  it 'should return the same value passed in' do
    qq = QQ.new %|
      a =>
      b =>
      c =>
    |

    expect( qq.run ).to eq 'abc'
  end

  it 'should accept inline strings with specific formatting' do
    qq = QQ.new 'a => b b => c c => '
    qq_compact = QQ.new 'a=>bb=>cc=>'
    qq_semicolons = QQ.new 'a => b; b => c; c => '

    expect( qq.run ).to eq 'cba'
    expect( qq.run ).to eq( qq_compact.run )
    expect( qq.run ).to eq( qq_semicolons.run )
  end

  it 'should create a new QQ object from a multi-dimensional array' do
    qq = QQ.new [
      ['a', 'b'], 
      ['b'],
    ]

    expect( qq.run.length ).to eq 2
    expect( qq.run[0] ).to eq 'b'
  end

  it 'should suppot jobs with multiple dependencies' do
    qq = QQ.new [
      ['a', ['b', 'c']],
      ['b'],
      ['c']
    ]

    expect( qq.run ).to eq 'bca'
  end

  it 'should support Job objects inside the array passed to the constructor' do
    qq = QQ.new [
      QQ::Job.new('a', ['b']),
      ['b', 'c'],
      QQ::Job.new('c'),
    ]

    expect( qq.run ).to eq 'cba'
  end

  it 'should create a new QQ object from a formatted string' do
    qq = QQ.new %|
      a =>
        b =>
      c => a

      d => a
    |

    expect( qq.length ).to eq 4
    expect( qq.job_list.select(&:has_dependencies?).length ).to eq 2
    expect( qq.run ).to eq 'abcd'
  end

  it 'should raise a SelfDependencyError when a job depends upon itself' do
    expect{ QQ.new 'a => a' }.to raise_exception(QQ::SelfDependencyError)
    expect{ 
      QQ.new [
        ['a', 'b'],
        QQ::Job.new('b', ['c']),
        ['c', ['a', 'b', 'c']],
      ]
    }.to raise_exception(QQ::SelfDependencyError)
  end
  
  it 'should sort the Jobs using TSort' do
    qq = QQ.new %|
      a =>
      b => c
      c => f
      d => a
      e => b
      f =>
    |

    sorted = qq.job_list.tsort_ids

    expect( sorted.find_index('f') ).to be < sorted.find_index('c')
    expect( sorted.find_index('c') ).to be < sorted.find_index('b')

    expect( qq.run ).to eq 'afcbde'

    qq.tsort!

    expect( qq.job_list.to_a.map(&:id).join ).to eq 'afcbde'
  end

  it 'should raise a CyclicDependencyError' do
    qq = QQ.new %|
      a =>
      b => c
      c => f
      d => a
      e =>
      f => b
    |

    expect { qq.tsort }.to raise_exception(QQ::CyclicDependencyError)
  end

  it 'should allow blocks to be passed to Jobs' do
    job = QQ::Job.new('a') { 'Hello World' }
    job_nesting = QQ::Job.new('b') do
      qq = QQ.new %|
        a => b
        b => c
        c => 
      |

      qq.run
    end

    job_no_block = QQ::Job.new('c')

    expect( job.run ).to eq 'Hello World'
    expect( job_nesting.run ).to eq 'cba'
    expect( job_no_block.run ).to eq 'c'
  end
end
