
using System.Collections.Generic;

static void partOne(string file)
{
    var score = 0;

    foreach (string line in System.IO.File.ReadLines(file))
    {
        List<char> stack = new List<char>();
        foreach (var sub in line)
        {
            if (sub == '[' || sub == '(' || sub == '<' || sub == '{')
            {
                stack.Add(sub);
            }
            else
            {
                char popped = stack[stack.Count - 1];
                stack.RemoveAt(stack.Count - 1);

                if (popped != '(' && sub == ')')
                {
                    score += 3;
                    break;
                }

                if (popped != '[' && sub == ']')
                {
                    score += 57;
                    break;
                }

                if (popped != '{' && sub == '}')
                {
                    score += 1197;
                    break;
                }

                if (popped != '<' && sub == '>')
                {
                    score += 25137;
                    break;
                }

            }
        }
    }

    Console.Out.WriteLine("Part 1: {0}", score);
}

static void partTwo(string file)
{
    var scores = new List<ulong>();

    foreach (string line in System.IO.File.ReadLines(file))
    {
        List<char> stack = new List<char>();
        var invalid = false;

        foreach (var sub in line)
        {
            if (sub == '[' || sub == '(' || sub == '<' || sub == '{')
            {
                stack.Add(sub);
            }
            else
            {
                char popped = stack[stack.Count - 1];
                stack.RemoveAt(stack.Count - 1);

                if (popped != '(' && sub == ')')
                {
                    invalid = true;
                    break;
                }

                if (popped != '[' && sub == ']')
                {
                    invalid = true;
                    break;
                }

                if (popped != '{' && sub == '}')
                {
                    invalid = true;
                    break;
                }

                if (popped != '<' && sub == '>')
                {
                    invalid = true;
                    break;
                }
            }
        }

        if (!invalid)
        {
            ulong score = 0;

            stack.Reverse();
            foreach (var s in stack)
            {
                score *= 5;
                if (s == '(')
                {
                    score += 1;
                }
                else if (s == '[')
                {
                    score += 2;
                }
                else if (s == '{')
                {
                    score += 3;
                }
                else if (s == '<')
                {
                    score += 4;
                }
            }

            scores.Add(score);
        }
    }

    scores.Sort();
    var mid_score = scores[scores.Count / 2];

    Console.Out.WriteLine("Part 2: {0}", mid_score);
}

const string file = "./input.txt";
partOne(file);
partTwo(file);