<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class AddRekomendatorIdToRekomendatorAttachment extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('rekomendator_attachment', function (Blueprint $table) {
            $table->char('rekomendator_id', 100)->nullable()->after('user_registration');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('rekomendator_attachment', function (Blueprint $table) {
            //
        });
    }
}
