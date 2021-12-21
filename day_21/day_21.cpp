#include <iostream>
#include <fstream>
#include <string>
#include <vector>

using namespace std;

void solve(string file)
{
    fstream new_file;
    new_file.open(file, ios::in);

    vector<int> init_pos;

    string line;
    while (getline(new_file, line))
    {
        init_pos.emplace_back(stoi(line.substr(line.length() - 1)));
    }

    new_file.close();

    // Part 1
    {
        vector<int> pos = init_pos;
        vector<int> score(pos.size());
        int num_rolls = 0;
        int i = 1;
        while (true)
        {
            num_rolls += 3;

            int a = i;
            int b = (i + 1 > 100) ? (i + 1 - 100) : (i + 1);
            int c = (i + 2 > 100) ? (i + 2 - 100) : (i + 2);

            pos[(i + 1) % 2] += a + b + c;
            while (pos[(i + 1) % 2] > 10)
            {
                pos[(i + 1) % 2] -= 10;
            }
            score[(i + 1) % 2] += pos[(i + 1) % 2];

            if (score[(i + 1) % 2] >= 1000)
            {
                cout << "Part 1: " << score[i % 2] * num_rolls << endl;
                break;
            }

            i += 3;
            if (i > 100)
            {
                i -= 100;
            }
        }
    }

    // Part 2
    {
        vector<int> pos = init_pos;
        long long memo[22][22][11][11];
        for (int i = 0; i < 22; ++i)
        {
            for (int j = 0; j < 22; ++j)
            {
                for (int m = 0; m < 11; ++m)
                {
                    for (int n = 0; n < 11; ++n)
                    {
                        memo[i][j][m][n] = 0;
                    }
                }
            }
        }
        memo[0][0][pos[0]][pos[1]] = 1;

        for (int i = 0; i < 21; ++i)
        {
            for (int j = 0; j < 21; ++j)
            {
                for (int m = 1; m <= 10; ++m)
                {
                    for (int n = 1; n <= 10; ++n)
                    {
                        for (int x = 1; x <= 3; ++x)
                        {
                            for (int y = 1; y <= 3; ++y)
                            {
                                for (int z = 1; z <= 3; ++z)
                                {
                                    auto pos = (m + x + y + z);
                                    while (pos > 10)
                                    {
                                        pos -= 10;
                                    }
                                    auto min_score = min(21, i + pos);
                                    if (min_score >= 21)
                                    {
                                        memo[min_score][j][pos][n] += memo[i][j][m][n];
                                    }
                                    else
                                    {
                                        for (int a = 1; a <= 3; ++a)
                                        {
                                            for (int b = 1; b <= 3; ++b)
                                            {
                                                for (int c = 1; c <= 3; ++c)
                                                {
                                                    auto new_pos = (n + a + b + c);
                                                    while (new_pos > 10)
                                                    {
                                                        new_pos -= 10;
                                                    }
                                                    auto new_score = min(21, j + new_pos);
                                                    memo[min_score][new_score][pos][new_pos] += memo[i][j][m][n];
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        long long x = 0;
        long long y = 0;
        for (int i = 0; i < 21; ++i)
        {
            for (int m = 1; m <= 10; ++m)
            {
                for (int n = 1; n <= 10; ++n)
                {
                    x += memo[21][i][m][n];
                    y += memo[i][21][m][n];
                }
            }
        }
        cout << x << ", " << y << endl;
        cout << "Part 2: " << max(x, y) << endl;
    }
}

int main(int argc, char *argv[])
{
    string file = "input.txt";
    if (argc == 2)
    {
        file = argv[1];
    }

    solve(file);
}