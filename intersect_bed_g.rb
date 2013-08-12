#!/usr/bin/env ruby

# intersect bed + check genotype simultaneously

require 'optparse'
opt = OptionParser.new
opt.on('-a A.bed') {|v| @a = v }
opt.on('-b B.bed') {|v| @b = v }
opt.on('-v') {|v| @v = v }
opt.on('-wb') {|v| @wb = v }
opt.on('-sorted') {|v| @sorted = v ? "-sorted" : "" }
argv = opt.parse(ARGV)

open("#{@a}") do |f|
  @a_ncol = f.gets.chomp.split("\t").length
end

@e = (@wb ? -1 : @a_ncol-1)
unless @v #intersect
  print `bedtools intersect #{@sorted} -loj -a #{@a} -b #{@b} | ruby -ane 'puts $F[0..#{@e}].join("\t") if $F[#{@a_ncol}] != "." and $F[3] == $F[#{@a_ncol}+3] and $F[4] == $F[#{@a_ncol}+4]'`
else
  print `bedtools intersect #{@sorted} -loj -a #{@a} -b #{@b} | ruby -ane 'puts $F[0..#{@e}].join("\t") if $F[#{@a_ncol}] == "." or $F[3] != $F[#{@a_ncol}+3] or $F[4] != $F[#{@a_ncol}+4]'`
end
