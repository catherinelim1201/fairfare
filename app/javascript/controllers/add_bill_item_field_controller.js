import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="add-bill-item-field"
export default class extends Controller {
    static targets = ["itemFields"]

  connect() {
  }

  addField(event) {
    event.preventDefault();
    const itemsLength = event.currentTarget.querySelectorAll(".item").length;

    const newInputsHtml = `
        <div class="item">
          <div class="mb-3 string required bill_items_name"><label class="form-label string required" for="bill_items_attributes_${itemsLength}_name">Name <abbr title="required">*</abbr></label><input class="form-control string required" type="text" name="bill[items_attributes][${itemsLength}][name]" id="bill_items_attributes_${itemsLength}_name"></div>
          <div class="mb-3 integer required bill_items_price"><label class="form-label integer required" for="bill_items_attributes_${itemsLength}_price">Price <abbr title="required">*</abbr></label><input class="form-control numeric integer required" type="number" step="1" name="bill[items_attributes][${itemsLength}][price]" id="bill_items_attributes_${itemsLength}_price"></div>
          <div class="mb-3 integer required bill_items_quantity"><label class="form-label integer required" for="bill_items_attributes_${itemsLength}_quantity">Quantity <abbr title="required">*</abbr></label><input class="form-control numeric integer required" type="number" step="1" name="bill[items_attributes][${itemsLength}][quantity]" id="bill_items_attributes_${itemsLength}_quantity"></div>
        </div>
        <hr>
    `

    this.itemFieldsTarget.insertAdjacentHTML("beforeend", newInputsHtml);

1
  }
}
