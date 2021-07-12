import { Components } from 'et_gds_design_system';

function setupReveal() {
  document.querySelectorAll('*[data-reveal-on-selector]').forEach(function (node) {
    const selector = node.attributes['data-reveal-on-selector'].value;
    const value = JSON.parse(node.attributes['data-reveal-on-value'].value);
    Components.RevealOnRadioButton(node, selector, value);
  });
}

export default function ClaimTypePage() {
  //setupReveal();
};
