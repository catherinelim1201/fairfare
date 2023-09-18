import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="add-splitees"
export default class extends Controller {
  connect() {
  }

  // async update(event) {
  //   event.preventDefault();
  //
  //   const formElement = event.currentTarget;
  //
  //   const response = await fetch(formElement.action, {
  //       method: "POST",
  //       headers: {
  //           "Accept": "plain/text"
  //       },
  //       body: new FormData(formElement)
  //   })
  //
  //   const data = await response.text();
  //
  //   const parser = new DOMParser();
  //   const newElement = parser.parseFromString(data, 'text/html').body.firstChild;
  //   formElement.replaceWith(newElement);
  // }

    async update(event) {
        event.preventDefault();

        const formElement = event.currentTarget;

        const response = await fetch(formElement.action, {
            method: "POST",
            headers: {
                "Accept": "plain/text"
            },
            body: new FormData(formElement)
        })
        //
        // const data = await response.text();
        //
        // const parser = new DOMParser();
        // const newElement = parser.parseFromString(data, 'text/html').body.firstChild;
        // this.element.replaceWith(newElement);
    }

    toggleForm() {
        this.element.querySelector(".card").classList.toggle("hidden");
    }
}
