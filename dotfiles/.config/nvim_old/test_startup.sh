#!/bin/sh
hyperfine "nvim --headless +qa" --warmup 5
