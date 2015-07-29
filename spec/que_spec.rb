require 'spec_helper'

describe Que do
  it "should create a new Queue object" do
    no_job_queue = Que.new
    queue = Que.new [
      [:a, :b], 
      [:b],
    ]

    expect( no_job_queue.jobs.length ).to eq 0
    expect( queue.jobs.length ).to eq 2
  end

  it "should parse a formatted string and produce a Queue with Jobs" do
    queue = Que.from_string %|
      a =>
      b =>
      c => a

      d => a
    |

    expect( queue.jobs.length ).to eq 4
    expect( queue.jobs.select(&:has_dependencies?).length ).to eq 2
  end
end
