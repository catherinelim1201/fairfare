import { Controller } from "@hotwired/stimulus"
import Swal from 'sweetalert2';

export default class extends Controller {
  static values = {
    invite: String,
    splitName: String
  }
  connect() {
  }

  getInvitationCode() {
    Swal.fire({
      title: 'Awesome!',
      html: `
      Share the following link with your friends to start splitting bills for ${this.splitNameValue} <br>
      <br>
        <input disabled=true value="localhost:3000/splits/invite?code=${this.inviteValue}"> 
      `,
      icon: 'success'
    })
  }
}
