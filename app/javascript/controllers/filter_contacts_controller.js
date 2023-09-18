import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="filter-contacts"
export default class extends Controller {
  static targets = ["list", "name", "phone", "searchedContacts"]
  static values = { splitId: String }


  connect() {
    console.log("I am connected");
    console.log("bye")
  }

  search(event) {
    const url = `/members/contact_lookup?phone=${this.phoneTarget.value}&name=${this.nameTarget.value}&split_id=${this.splitIdValue}`

    fetch(url, {
      method: "GET",
      headers: {
        accept: "application/json"
      }
    })
        .then(response => response.json())
        .then((data) => {
          if (data.member_matched_by_phone) {
            this.nameTarget.value = data.member_matched_by_phone.name;
            this.nameTarget.disabled = true;
          } else {
              if (this.nameTarget.disabled) {
                  this.nameTarget.disabled = false;
                  this.nameTarget.value = "";
              }
          }

          this.searchedContactsTarget.innerHTML = data.contacts;
        })
  }

  select(e) {
      const memberData = e.currentTarget.dataset
      console.log(memberData)
      this.nameTarget.value = memberData.memberName;
      this.phoneTarget.value = memberData.memberPhone;
  }

  clear() {
      this.nameTarget.value = "";
      this.phoneTarget.value = "";
  }
}
