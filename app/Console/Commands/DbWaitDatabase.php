<?php
namespace App\Console\Commands;

use DB;
use Illuminate\Console\Command;
use Illuminate\Database\QueryException;

class DbWaitDatabase extends Command
{
    const WAIT_SLEEP_TIME = 2;

    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'db:wait';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Waits for database availability.';

    /**
     * Execute the console command.
     *
     * @param DB $db
     *
     * @return integer
     */
    public function handle(DB $db)
    {
        for ($i = 0; $i < 60; $i += self::WAIT_SLEEP_TIME) {
            try {
                $db::select('SHOW TABLES');
                return 0;
            } catch (QueryException $e) {
                sleep(self::WAIT_SLEEP_TIME);
                continue;
            }
        }

        return 1;
    }
}
