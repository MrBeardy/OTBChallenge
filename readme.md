# Que 0.0.4

Que is a small library that takes a formatted string (or multi-dimensional 
array) as input and stores it as Jobs with optional dependencies.

This job list can then be sorted using 
[TSort](http://ruby-doc.org/stdlib/libdoc/tsort/rdoc/TSort.html) to ensure
proper dependency ordering and Cyclic dependency safety.

# Usage

```ruby
require 'que'

que = Que.from_string %|
  a =>
  b => c
  c => f
  d => a
  e => b
  f =>
|

p que.job_list.tsort_ids
p que.run

# results
# 
# ["a", "f", "c", "b", "d", "e"]
# "afcbde"

```

# Roadmap

- Turn the library into a Gem
- Add functionality to Jobs, allow them to store Procedures to be called when
  run.

# License

The MIT License (MIT)

Copyright (c) 2015 Michael Hibbs

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
