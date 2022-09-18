<div class="col-md-6">
    <!-- <br><br><br>
    <h6 class="text-info">DATA REKOMENDATOR</h6> -->
    <!-- <hr style="border-top:1px solid #18a2b8" /> -->
    <div class="row">
        <div class="form-group col-md-12">
            <label>No KTP Rekomendator</label>
            <input type="text" class="form-control" wire:model="id_ktp_rekomendator">
            @error('user_rekomendator') <span class="text-danger">{{ $message }}</span> @enderror
        </div>
        

        <br>
        <div class="col-md-12">
            <form class="form-auth-small" method="POST" wire:submit.prevent="saveattachmentrekomendator" action="">
                <table class="table">
                    <thead style="background:#eee;">
                        <tr>
                            <th>No</th>
                            <th>Document Name</th>
                            <th>File</th>
                        </tr>
                    </thead>
                    <?php 
                    
                    ?>
                    <tbody>
                        @if($id_ktp_rekomendator)
                        @foreach($dataattachment as $k =>  $item)
                            <tr>
                                <td>{{ $k+1 }}</td>
                                <td>{{ $item->attachment_rekomendator_name}}</td>
                                <td><a href="{{ asset('storage/'. $item->attachment_rekomendator_file) }}" target="_blank"><i class="fa fa-image"></i></a></td>
                                
                                <!-- <td class="text-right">livewire('finance.weekly-opex-editable',['data'=>$item,'field'=>'amount'],key($item->id))</td> -->
                                
                            </tr>
                        @endforeach
                        @endif
                        @if($insert)
                            <tr>
                                <td></td>
                                <td>
                                    
                                    <input type="text" class="form-control" wire:model="attachment_rekomendator_name">
                                    <input type="hidden" class="form-control" wire:model="rand_id">
                                    @error('attachment_rekomendator_name')
                                        <span class="text-danger">{{ $message }}</span>
                                    @enderror
                                </td>
                                <td>
                                    
                                    <input type="file" class="form-control" id="attachment_rekomendator_file" wire:model="attachment_rekomendator_file">
                                    @error('attachment_rekomendator_file')
                                        <span class="text-danger">{{ $message }}</span>
                                    @enderror
                                </td>                       
                            </tr>
                           
                            <tr>
                                <td colspan="5">
                                    <button wire:loading.remove wire:target="saveattachmentrekomendator" type="submit" class="badge badge-info badge-active"><i class="fa fa-save"></i> Save</button>
                                    <a href="javascript:void(0)" wire:loading.remove wire:target="saveattachmentrekomendator" wire:click="$set('insert',false)" class="badge badge-danger badge-active"><i class="fa fa-close"></i> Cancel</a>
                                </td>
                            </tr>
                        @endif
                    </tbody>
                </table>
                @if($insert==false)
                    @if($umur < 50)
                        <a href="javascript:void(0)" wire:click="$set('insert',true)" class="badge badge-info badge-active"><i class="fa fa-plus"></i> Attachment</a>
                    @endif
                @endif
            </form>
        </div>
    </div>
</div>


