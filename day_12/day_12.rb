#!/usr/bin/env ruby
# frozen_string_literal : true

require "set"

def part_one(file)
    def visit(name, visited, path, cave)
        if name === 'end' then
            # puts "Path: #{path}"
            return 1
        end
        
        v = visited.clone
        p = path.clone
        
        if name.upcase != name then
            v << name
        end
        p << name
    
        return (cave[name]&.sum do |c|
            unless v.include?(c) then
                visit(c, v, p, cave)
            else
                0
            end
        end || 0)
    end

    cave = {}
    File.foreach(file) do |line|
        splits = line.split("-")
        s = splits[0].strip
        e = splits[1].strip
        cave[s] ||= []
        cave[s] << e
        
        cave[e] ||= []
        cave[e] << s
    end

    count = visit("start", Set[], [], cave)

    puts "Part 1: #{count} unique paths"
end

def part_two(file)
    def visit(name, visited, path, cave, hit_twice)
        if name === 'end' then
            # puts "Path: #{path}"
            return 1
        end
        
        p = path.clone
        p << name
    
        return (cave[name]&.sum do |c|
            v = visited.clone
            v[c] ||= 0

            if c.upcase != c then
                v[c] ||= 0
                v[c] += 1
            end

            if v[c] < 2 then
                visit(c, v, p, cave, hit_twice)
            elsif v[c] == 2 then
                if hit_twice then
                    0
                else
                    visit(c, v, p, cave, true)
                end
            else
                0    
            end
        end || 0)
    end

    cave = {}
    File.foreach(file) do |line|
        splits = line.split("-")
        s = splits[0].strip
        e = splits[1].strip
        cave[s] ||= []
        cave[s] << e
        
        cave[e] ||= []
        cave[e] << s
    end

    count = visit("start", {"start" => 1000}, [], cave, false)

    puts "Part 2: #{count} unique paths"
end

part_one("input.txt")
part_two("input.txt")