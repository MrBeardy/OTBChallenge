require 'spec_helper'

describe Que do
  it "should create a new Que object" do
    no_job_que = Que.new
    que = Que.new [
      [:a, :b], 
      [:b],
    ]

    expect( no_job_que.length ).to eq 0
    expect( que.length ).to eq 2
  end

  it "should parse a formatted string and produce a Que with Jobs" do
    que = Que.from_string %|
      a =>
        b =>
      c => a

      d => a
    |

    expect( que.length ).to eq 4
    expect( que.job_list.select(&:has_dependencies?).length ).to eq 2
  end
  
  it "should sort the Jobs using TSort" do
    que = Que.from_string %|
      a =>
      b => c
      c => f
      d => a
      e => b
      f =>
    |

    sorted = que.job_list.tsort_ids

    expect( sorted.find_index("f") ).to be < sorted.find_index("c")
    expect( sorted.find_index("c") ).to be < sorted.find_index("b")

    expect( que.run ).to eq "afcbde"
  end

  it "should raise a TSort::Cyclic exception" do
    que = Que.from_string %|
      a =>
      b => c
      c => f
      d => a
      e =>
      f => b
    |

    expect { que.tsort }.to raise_exception(Que::CyclicDependencyError)
  end
end
