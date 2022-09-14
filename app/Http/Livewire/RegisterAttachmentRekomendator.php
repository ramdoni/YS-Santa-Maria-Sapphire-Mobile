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

	

	protected $listeners = ['save-all'=>'save_all'];

	public function render()
    {
        if($this->Id_Ktp){
            $data = \App\Models\RekomendatorAttachment::where('rekomendator_id', $this->Id_Ktp)->get();
        }else{
            $data = [];
        }
		
        return view('livewire.register-attachment-rekomendator')->with(['data'=>$data]);
    }

	public function mount()
	{
		$this->rand_id = rand();
		$this->form_no = date('ymd').UserMember::count();
	}

	public function save_all($num)
	{
		if($num==1) $this->validate_form_1 = true;
		if($num==2) $this->validate_form_2 = true;
		if($num==3) $this->validate_form_3 = true;
		if($num==4) $this->validate_form_4 = true;
		if($num==5) $this->validate_form_5 = true;
		
		if($this->umur >=65 and $this->umur <=74){ // di atas 65 dan di bawah 74 tahun wajib mendaftarkan satu anggota
            if($this->validate_form_1){
				$this->register();
			}
        }elseif($this->umur >=75 and $this->umur <= 79){ // diatas 75 tahun wajib mendaftarkan 2 anggota
            if($this->validate_form_1 and $this->validate_form_2 ){
				$this->register();
			}
        }elseif($this->umur>=80){
            if($this->validate_form_1==true and $this->validate_form_2==true and $this->validate_form_3==true and $this->validate_form_4==true and $this->validate_form_5==true){
				$this->register();
			}
		}
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