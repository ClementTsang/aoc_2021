package main.kotlin

import java.io.File
import java.io.InputStream

fun getValue(varMapping: MutableMap<String, Int>, p: Pair<String?, Int?>): Int {
    return if (p.first != null) {
        if (varMapping.containsKey(p.first)) {
            varMapping[p.first]!!
        } else {
            varMapping[p.first!!] = 0
            varMapping[p.first]!!
        }
    } else {
        p.second!!
    }
}

fun getVar(varMapping: MutableMap<String, Int>, value: String): Int {
    if (!varMapping.containsKey(value)) {
        varMapping[value] = 0
    }
    return varMapping[value]!!
}

fun getVal(value: String): Pair<String?, Int?> {
    val r = value.toIntOrNull()
    return if (r == null) {
        Pair(value, null)
    } else {
        Pair(null, r)
    }
}

enum class Operation {
    Inp,
    Add,
    Mul,
    Div,
    Mod,
    Eql
}

fun eval(
    vars: MutableMap<String, Int>,
    memo: MutableMap<String, IntArray?>,
    instructions: MutableList<Triple<Operation, String, Pair<String?, Int?>>>,
    currentInstruction: Int,
    range: IntArray
): IntArray? {
    if (currentInstruction == instructions.size) {
        return if (vars["z"]!! == 0) {
            intArrayOf()
        } else {
            null
        }
    }

    val instruction = instructions[currentInstruction]
    when (instruction.first) {
        Operation.Inp -> {
            for (i in range) {
                val newVars = vars.toMutableMap()
                newVars[instruction.second] = i

                val key = "${newVars}-${currentInstruction + 1}"
                val eval = if (memo.containsKey(key)) {
                    memo[key]
                } else {
                    val res = eval(newVars, memo, instructions, currentInstruction + 1, range)
                    memo[key] = res
                    res
                }
                if (eval != null) {
                    return intArrayOf(i) + eval
                }
            }
            return null
        }
        Operation.Add -> {
            vars[instruction.second] =
                getVar(vars, instruction.second) + getValue(vars, instruction.third)
        }
        Operation.Mul -> {
            vars[instruction.second] =
                getVar(vars, instruction.second) * getValue(vars, instruction.third)
        }
        Operation.Div -> {
            vars[instruction.second] =
                getVar(vars, instruction.second) / getValue(vars, instruction.third)
        }
        Operation.Mod -> {
            vars[instruction.second] =
                getVar(vars, instruction.second) % getValue(vars, instruction.third)
        }
        Operation.Eql -> {
            vars[instruction.second] =
                if (getVar(vars, instruction.second) == getValue(vars, instruction.third)
                ) {
                    1
                } else {
                    0
                }
        }
    }
    return eval(vars, memo, instructions, currentInstruction + 1, range)
}

fun solve(file: String) {
    val inputStream: InputStream = File(file).inputStream()
    val lineList = mutableListOf<String>()
    inputStream.bufferedReader().forEachLine { lineList.add(it) }

    val instructions = mutableListOf<Triple<Operation, String, Pair<String?, Int?>>>()

    for (line in lineList) {
        val splits = line.split(" ")
        if (splits[0] == "inp") {
            instructions.add(Triple(Operation.Inp, splits[1], Pair(null, null)))
        } else if (splits[0] == "add") {
            instructions.add(Triple(Operation.Add, splits[1], getVal(splits[2])))
        } else if (splits[0] == "mul") {
            instructions.add(Triple(Operation.Mul, splits[1], getVal(splits[2])))
        } else if (splits[0] == "div") {
            instructions.add(Triple(Operation.Div, splits[1], getVal(splits[2])))
        } else if (splits[0] == "mod") {
            instructions.add(Triple(Operation.Mod, splits[1], getVal(splits[2])))
        } else if (splits[0] == "eql") {
            instructions.add(Triple(Operation.Eql, splits[1], getVal(splits[2])))
        } else {
            println("Something went wrong...")
        }
    }

    run {
        val memo = mutableMapOf<String, IntArray?>()
        val vars = mutableMapOf<String, Int>()
        println("Part 1: ${eval(vars, memo, instructions, 0, (9 downTo 1).toList().toIntArray())!!.joinToString("")}")
    }

    run {
        val memo = mutableMapOf<String, IntArray?>()
        val vars = mutableMapOf<String, Int>()
        println("Part 1: ${eval(vars, memo, instructions, 0, (1..9).toList().toIntArray())!!.joinToString("")}")
    }
}

fun main(args: Array<String>) {
    var file = "input.txt"
    if (args.size == 1) {
        file = args[0]
    }

    solve(file)
}