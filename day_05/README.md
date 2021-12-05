# Day 5

PHP day today. I've never written PHP before, but it was simple enough to figure out what to use - the joys of being
used to C-like imperative languages, I guess.

One thing that I'll admit got me was that I tried to do something silly like:

```php
$coord = "$x" . ',' . "$y";
if (in_array($coord, $seen)) {
    // Handle existing case
} else {
    // Add value
}
```

Unfortunately, this approach is terribly slow, even for the tiny inputs they give in `input.txt` - it was actually
hanging up, and I was wondering what could possibly be wrong.

I should have realized much sooner (the argument being called `$needle` should have tipped me off) that `in_array`
actually checks _every_ element sequentially.

I think I gravitated to this approach at first because I'm used to how Python will error out at you if you try
something like this:

```python
x = {}
x[10] = 100
x[100] # <- KeyError: 100
```

Thankfully, you can use `isset` to do an existence check, [and it's much faster](https://stackoverflow.com/a/13483548).
As soon as I changed my code to something like this:

```php
if (isset($seen[$x][$y])) {
    // Handle existing case
} else {
    // Add value
}
```

It was instant.

---

To run, go this directory and execute:

```bash
./day_5.php input.txt
```

If you don't include a text file it will default to `input.txt`.
