// author: Maciej Dudek
// 29.08.2020

import tango.io.Stdout;
import tango.math.Math;
import Integer = tango.text.convert.Integer;

void main(char[][] arg)
{
    int N = Integer.toInt(arg[1]);
    bool[] numbers;
    numbers.length = N;

    for(int i = 0; i < N; i++) {
        numbers[i] = true;
    }

    for(int i = 2; i < sqrt(cast(real)N); i++) {
        if(numbers[i] == true) {
            for(int j = 2*i; j < N; j+=i) {
                numbers[j] = false;
            }
        }
    }

    Stdout("[ ");
    for(int i = 0; i < N; i++) {
        if(numbers[i] == true) {
            Stdout(i)(" ");
        }
    }
    Stdout("]").newline;
}