<?php

namespace App\Http\Livewire;

use Livewire\Component;
use Illuminate\Support\Facades\Auth;

class Login extends Component
{
    public $email;
    public $password,$remember_me=false;
    public $message;
    public function render()
    {
        return view('livewire.login')
                ->layout('layouts.auth');
    }

    public function login()
    {
        $this->validate([
                'email' => 'required',
                'password' => 'required',
            ],
            [
                'email.required'=>'NIK / No Anggota is required'
            ]
        );
        if(is_numeric($this->email)){ 
            $credentials = ['nik'=>$this->email,'password'=>$this->password]; // Login with NIK
        }else{
            $credentials = ['email'=>$this->email,'password'=>$this->password];
        }

        if (Auth::attempt($credentials,$this->remember_me)) {
            // Authentication passed...
            return redirect('/');
        }
        else $this->message = __('Email / Password incorrect please try again');
    }
}
