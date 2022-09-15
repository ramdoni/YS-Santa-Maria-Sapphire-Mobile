<?php
namespace App\Http\Livewire;

use Livewire\Component;
use Livewire\WithFileUploads;
use App\Models\UserMember;
use App\Models\User;
use App\Models\BankAccount;
use App\Models\RekomendatorAttachment;
use Illuminate\Validation\Rule; 
use Illuminate\Support\Facades\Hash;


class RegisterAttachmentRekomendator extends Component 
{
	use WithFileUploads;
	
	public $insert=false;
	public $user_id_recomendation, $attachment_rekomendator_file, $attachment_rekomendator_name, $rand_id, $Id_Ktp, $tanggal_lahir, $umur;

	

	// protected $listeners = ['save-all'=>'save_all'];

	public function render()
    {
        // if($this->Id_Ktp){
            $data = \App\Models\RekomendatorAttachment::where('rekomendator_id', '2208000185');
            // dd($data->get());
        // }else{
            // $data = [];
        // }
        
		
        
        return view('livewire.register-attachment-rekomendator')->with(['data'=>$data]);
    }

	public function mount()
	{
		$this->rand_id = rand();
		$this->form_no = date('ymd').UserMember::count();
	}

	public function saveattachmentrekomendator()
    {
        // $this->validate([
        //     'project_id'=>'image:max:1024',
        //     'week'=>'required',
        // ]);

        $data 									= new RekomendatorAttachment();
        // $data->user_registration			 	= $this->rand_id;
        $data->rekomendator_id				 	= $this->Id_Ktp;
        $data->attachment_rekomendator_file 	= $this->attachment_rekomendator_file;
        $data->attachment_rekomendator_name 	= $this->attachment_rekomendator_name;
        $data->save();

        $this->insert = false;
        $this->reset(['attachment_rekomendator_file']);
        $this->reset(['attachment_rekomendator_name']);
        $this->emit('reload');
    }


	// public function updateattachmentrekomendator($rand_id, $id_user_registration)
    // {
    //     $data 						= RekomendatorAttachment::where('user_registration', $this->Id_Ktp)->get();
    //     $data->user_registration 	= $user_registration;
    //     $data->save();

    //     $this->insert = false;
    //     // $this->reset(['budget']);
    //     // $this->emit('reload');
    // }
}