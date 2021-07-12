/**
 * Used on a multiples page to allow adding, removal and updating of the count.
 * @constructor
 */
export default function RemoveMultiple() {
  setupClickHandler();
  setInitialState();
}

function setupClickHandler() {
  document.addEventListener('click', function (e) {
    if (!e.target.matches('a[data-multiple-remove]')) {
      return;
    }

    e.preventDefault();
    removeMultiple(e.target.attributes['data-multiple-remove'].value)
  });
}

function setInitialState() {
  const multiples = document.querySelectorAll('.multiple');
  if(multiples.length <= 1) {
    multiples[0].querySelector('a[data-multiple-remove]').style.display = 'none';
    updateCount();
    return;
  }
  multiples.forEach(function(multiple, index) {
    const markForDestroy = multiple.querySelector('input[data-multiple-mark-for-destroy]');
    multiple.style.display = markForDestroy.value === 'true' ? 'none' : 'block';
  });
}

function removeMultiple(id) {

  const multiple = document.querySelector(`#${id}`)
  if(!multiple) { return }

  multiple.style.display = 'none';
  markForDeletion(multiple);
  updateCount();
}

function markForDeletion(multiple) {
  const markForDestroy = multiple.querySelector('input[data-multiple-mark-for-destroy]');
  markForDestroy.value = 'true';
}

function updateCount() {
  const multiples = visibleMultiples();
  multiples.forEach(function(multiple, index) {
    replaceNumber(multiple, index + 2);
  });
}

function replaceNumber(multiple, newNumber) {
  let legend = multiple.querySelector('legend:first-child');
  legend.innerHTML = legend.innerHTML.replace(/\d+/g, newNumber);
}

function visibleMultiples() {
  let multiples = [];
  document.querySelectorAll('.multiple').forEach(function(multiple) {
    if(multiple.style.display === 'none') { return }

    multiples.push(multiple);
  });
  return multiples;
}
