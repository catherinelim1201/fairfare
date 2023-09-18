import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="image-preview"
export default class extends Controller {
  connect() {
    console.log('test')
  }

  preview(event) {
      const input = event.target;
      if (input.files && input.files[0]) {
          const reader = new FileReader();
          reader.onload = (e) => {
              const preview = document.getElementById('preview');
              preview.src = e.target.result;
          }
          reader.readAsDataURL(input.files[0]);
      }
  }
}
