# Testing
In order to run the built-in tests, run `make` here.

This will copy the Python sources and create various output files (simple outputs contain the final weight found by the algorithm, total "results" files contain all info about the tests).

To remove these extra files, run `make clean`.

Do note that the testing is **complete** and may take 10–20 minutes. You could modify the `checker.sh` script if you wish so, but this is not recommended.

Feel free to create your own tests following the instructions in the `src` directory. You can even place your own tests alongside the built-in ones under `inputs/...` .