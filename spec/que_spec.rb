require 'spec_helper'

describe Que do
  it 'should return a blank string' do
    que = Que.new

    expect( que.run ).to eq ''
  end

  it 'should return a single job' do
    que = Que.new ' a => '

    expect( que.run ).to eq 'a'
  end

  it 'should return the same value passed in' do
    que = Que.new %|
      a =>
      b =>
      c =>
    |

    expect( que.run ).to eq 'abc'
  end

  it 'should accept inline strings with specific formatting' do
    que = Que.new 'a => b b => c c => '
    que_compact = Que.new 'a=>bb=>cc=>'
    que_semicolons = Que.new 'a => b; b => c; c => '

    expect( que.run ).to eq 'cba'
    expect( que.run ).to eq( que_compact.run )
    expect( que.run ).to eq( que_semicolons.run )
  end

  it 'should create a new Que object from a multi-dimensional array' do
    que = Que.new [
      [:a, :b], 
      [:b],
    ]

    expect( que.length ).to eq 2
  end

  it 'should create a new Que object from a formatted string' do
    que = Que.new %|
      a =>
        b =>
      c => a

      d => a
    |

    expect( que.length ).to eq 4
    expect( que.job_list.select(&:has_dependencies?).length ).to eq 2
  end

  it 'should raise a SelfDependenceError when a job depends upon itself' do
    expect{ Que.new 'a => a' }.to raise_exception(Que::SelfDependenceError)
  end
  
  it 'should sort the Jobs using TSort' do
    que = Que.new %|
      a =>
      b => c
      c => f
      d => a
      e => b
      f =>
    |

    sorted = que.job_list.tsort_ids

    expect( sorted.find_index('f') ).to be < sorted.find_index('c')
    expect( sorted.find_index('c') ).to be < sorted.find_index('b')

    expect( que.run ).to eq 'afcbde'
  end

  it 'should raise a TSort::Cyclic exception' do
    que = Que.new %|
      a =>
      b => c
      c => f
      d => a
      e =>
      f => b
    |

    expect { que.tsort }.to raise_exception(TSort::Cyclic)
  end
end
