module krt::thread;

import wdk;

// x64
const PASSIVE_LEVEL = 0;                 // Passive release level
const LOW_LEVEL = 0;                     // Lowest interrupt level
const APC_LEVEL = 1;                     // APC interrupt level
const DISPATCH_LEVEL = 2;                // Dispatcher level
const CMCI_LEVEL = 5;                    // CMCI handler level
const CLOCK_LEVEL = 13;                  // Interval clock level
const IPI_LEVEL = 14;                    // Interprocessor interrupt level
const DRS_LEVEL = 14;                    // Deferred Recovery Service level
const POWER_LEVEL = 14;                  // Power failure level
const PROFILE_LEVEL = 15;                // timer used for profiling.
const HIGH_LEVEL = 15;                   // Highest interrupt level

fn Kirql current_irql() @inline
{
    return wdk::keGetCurrentIrql();
}

