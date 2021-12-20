#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

void solve(char file[], int dim_orig, int num_runs)
{
    char *line = NULL;
    size_t len = 0;
    size_t read;

    int offset = 4 * num_runs;
    int half = offset / 2;

    int dim = dim_orig + offset;

    char grid[dim][dim];
    char out[dim][dim];
    char iea[512];

    for (int i = 0; i < dim; ++i)
    {
        for (int j = 0; j < dim; ++j)
        {
            grid[i][j] = '.';
            out[i][j] = '.';
        }
    }

    FILE *stream = fopen(file, "r");
    size_t row = 0;
    while (getline(&line, &len, stream) != -1)
    {
        if (strlen(line) != 1)
        {
            if (row == 0)
            {
                for (size_t i = 0; i < 512; ++i)
                {
                    iea[i] = line[i];
                }
            }
            else
            {
                for (int i = 0; i < dim_orig; ++i)
                {
                    if (line[i] != '\n')
                    {
                        grid[row - 1 + half][i + half] = line[i];
                    }
                }
            }

            row += 1;
        }
    }

    for (int y = 0; y < num_runs; ++y)
    {
        char v = (y % 2 == 0) ? '.' : '#';
        int off = half - (2 * (y + 1));
        for (int i = off; i < dim - off; ++i)
        {
            for (int j = off; j < dim - off; ++j)
            {
                char bs[10] = {'0', '0', '0', '0', '0', '0', '0', '0', '0', '\0'};
                int c = 0;
                for (int m = -1; m <= 1; ++m)
                {
                    for (int n = -1; n <= 1; ++n)
                    {
                        int row = i + m;
                        int col = j + n;

                        char r;
                        if (row < off || row >= (dim - off) || col < off || col >= (dim - off))
                        {
                            r = v;
                        }
                        else
                        {
                            r = grid[row][col];
                        }

                        if (r == '.')
                        {
                            bs[c] = '0';
                        }
                        else
                        {
                            bs[c] = '1';
                        }
                        c += 1;
                    }
                }

                int val = (int)strtol(bs, NULL, 2);
                out[i][j] = iea[val];
            }
        }

        if (y + 1 < num_runs)
        {
            v = (y % 2 == 0) ? '#' : '.';
            for (int i = off - 2; i < dim - (off - 2); ++i)
            {
                for (int j = off - 2; j < dim - (off - 2); ++j)
                {
                    grid[i][j] = v;
                }
            }
        }

        for (int i = off; i < dim - off; ++i)
        {
            for (int j = off; j < dim - off; ++j)
            {
                grid[i][j] = out[i][j];
                out[i][j] = '.';
            }
        }

        if (y == 1 || y == 49)
        {
            int count = 0;
            for (int i = 0; i < dim; ++i)
            {
                for (int j = 0; j < dim; ++j)
                {
                    if (grid[i][j] == '#')
                    {
                        count += 1;
                    }
                }
            }
            printf("Part %d: %d\n", (y == 1 ? 1 : 2), count);
        }
    }

    free(line);
    fclose(stream);
}

int main(int argc, char *argv[])
{
    char *file = "input.txt";
    size_t dim = 100;
    if (argc == 3)
    {
        file = argv[1];
        dim = atoi(argv[2]);
    }

    solve(file, dim, 50);
}