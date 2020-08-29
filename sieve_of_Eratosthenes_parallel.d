// author: Maciej Dudek
// 29.08.2020

// sources:
// [1] Theory about parallel sieve of Eratosthenes (page 15):
// http://www.shodor.org/media/content//petascale/materials/UPModules/sieveOfEratosthenes/module_document_pdf.pdf


import tango.io.Stdout;
import tango.math.Math;
import tango.core.Thread;

class DeclareThread : Thread
{
    private bool[] local_array;
    private int local_start;
    private int local_end;

    this(bool[] array, int start, int end)
    {
        local_array = array;
        local_start = start;
        local_end = end;
        super(&run);
    }

    void run()
    {
        for(int i = local_start; i < local_end; i++) {
            local_array[i] = true;
        }
        // Stdout("Wątek ")(this)(" ")(local_start)(" ")(local_end)(" skończył pracę.").newline;
    }
}

class ChoiceThread : Thread
{
    private bool[] local_array;
    private int position;


    this(bool[] array, int pos)
    {
        local_array = array;
        position = pos;
        super(&run);
    }

    void run()
    {
        synchronized {
            local_array[position] = false;
        }
        // Stdout(" ")(position)(" done").newline;
    }
}

int main()
{
    // declaration array
    int array_size = 100000;
    bool[] array;
    array.length = array_size;

    // 1st step - write out the numbers - PARALLEL
    Thread dt;
    ThreadGroup dtg = new ThreadGroup();
    for(int i = 0; i < array_size; i+=(array_size/4)) {
        dt = new DeclareThread(array, i, i+(array_size/4));
        dtg.add(dt);
        dt.start;
    }
    dtg.joinAll;

    // 2nd step SEQUENCION - circle the smallest unmarked, uncircled number in the list
    for(int i = 2; i < sqrt(cast(real)array_size); i++) {
        if(array[i]) {
            // 3rd step PARALLEL - for each number bigger than the biggest circled number,
            // mark the number if it's a multiple of the biggest circled number
            Thread ct;
            ThreadGroup ctg = new ThreadGroup();
            for(int j = 2*i; j < array_size; j += i) {
                ct = new ChoiceThread(array, j);
                ctg.add(ct);
                ct.start;
            }
            ctg.joinAll;
        }
        // 4th step SEQUENCION - repeat 2nd and 3rd steps
    }

    // list prime numbers
    Stdout("[ ");
    for(int i = 2; i < array_size; i++) {
        if(array[i]) {
            Stdout(i)(" ");
        }
    }
    Stdout("]").newline;

    return 0;
}