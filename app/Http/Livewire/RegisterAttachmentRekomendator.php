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
	
	public $insert=false,$data;
	public $user_id_recomendation, $attachment_rekomendator_file, $attachment_rekomendator_name, $rand_id, $Id_Ktp, $tanggal_lahir, $umur, $id_ktp_rekomendator;

	public function render()
    {
        $dataattachment = RekomendatorAttachment::where('user_member_id', $this->data->id)->get();

        return view('livewire.register-attachment-rekomendator')->with(['dataattachment'=>$dataattachment]);
    }

	public function mount(UserMember $data)
	{
        $this->data = $data;
		$this->rand_id = rand();
		$this->form_no = date('ymd').UserMember::count();
	}

    public function delete(RekomendatorAttachment $data)
    {
        $data->delete();
    }

	public function saveattachmentrekomendator()
    {
        $this->validate([
            'attachment_rekomendator_file' => 'required|image|mimes:jpeg,png,jpg,gif,svg|max:2048',
            'attachment_rekomendator_name' => 'required'
        ]);

        $data 									= new RekomendatorAttachment();
        $data->rekomendator_id				 	= $this->id_ktp_rekomendator;
        $data->attachment_rekomendator_name 	= $this->attachment_rekomendator_name;
        $data->user_member_id = $this->data->id;
        $data->save();

        $name = "{$data->id}.".$this->attachment_rekomendator_file->extension();
        $this->attachment_rekomendator_file->storeAs("public/rekomendator/{$this->data->id}", $name);
        $data->attachment_rekomendator_file = "storage/rekomendator/{$this->data->id}/{$name}";
        $data->save();

        $this->insert = false;
        $this->reset(['attachment_rekomendator_file']);
        $this->reset(['attachment_rekomendator_name']);
        $this->emit('reload');
    }
}