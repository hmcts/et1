/**
 *
 * Hides or shows (reveals) an element based on a radio button group
 * @param node {Element} The element to hide or show
 * @param selector {String} A css selector to identify the radio button group
 * @param value {String} The value that the radio button group must be set to in order to show the element
 */
export default function RevealOnRadioButton(node, selector, value) {
  document.addEventListener('change', function(e) {
    if(!e.target.matches(selector)) {
      return;
    }


    if((e.target.value === value || (Array.isArray(value) && value.indexOf(e.target.value) >= 0)) && e.target.checked) {
      showNode(node);
    } else {
      hideNode(node);
    }
  });
  setInitialState(node, selector, value);


}
function showNode(node) {
  node.style.display = 'block';
}

function hideNode(node) {
  node.style.display = 'none';
}

function setInitialState(node, selector, value) {
  if(isCorrectValue(node, selector, value)) {
    showNode(node);
  } else {
    hideNode(node);
  }
}

function isCorrectValue(node, selector, value) {
  let isChecked = false;
  document.querySelectorAll(selector).forEach(function(radioButton) {
    if(radioButton.value == value  && radioButton.checked) {
      isChecked = true
      return;
    }

  });
  return isChecked;
}
