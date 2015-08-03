require 'spec_helper'

describe "On The Beach Exercise", otb: true do
  it 'should return an empty string' do    
    expect(QQ.new('').run).to eq ''
  end

  it 'should return a single job' do
    expect(QQ.new(' a => ').run).to eq 'a'
  end

  it 'should return the same order' do
    result = QQ.new(%(
      a =>
      b =>
      c =>
    )).run

    expect(result).to eq 'abc'
  end

  it 'should sort based on dependency' do
    qq = QQ.new %(
      a =>
      b => c
      c => f
      d => a
      e => b
      f =>
    )
  
    # Sort the jobs and store only the IDs
    s = qq.job_list.tsort_ids

    # f before c
    expect(s.find_index('f')).to be < s.find_index('c')

    # c before b
    expect(s.find_index('c')).to be < s.find_index('b')
    expect(s.find_index('b')).to be < s.find_index('e')

    # b before e
    expect(s.find_index('a')).to be < s.find_index('d')

    # afcbde
    expect(s.join).to eq 'afcbde'
  end

  it 'should raise an error stating that jobs can’t depend on themselves' do
    expect do
      QQ.new %(
        a =>
        b =>
        c => c
      )
    end.to raise_exception(QQ::SelfDependencyError)
  end

  it 'should raise an error stating that jobs can’t have circular dependencies' do
    expect do
      QQ.new(%(
        a =>
        b => c
        c => f
        d => a
        e =>
        f => b
      )).run
    end.to raise_exception(QQ::CyclicDependencyError)
  end
end
