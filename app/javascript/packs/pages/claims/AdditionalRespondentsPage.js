import { Components } from 'et_gds_design_system';
import RemoveMultiple from "../../components/RemoveMultiple";

function setupReveal() {
  document.querySelectorAll('*[data-reveal-on-selector]').forEach(function (node) {
    const selector = node.attributes['data-reveal-on-selector'].value;
    const value = node.attributes['data-reveal-on-value'].value;
    Components.RevealOnRadioButton(node, selector, value);
  });
}

function setupRemoveMultiple() {
  RemoveMultiple();
}

export default function AdditionalRespondentsPage() {
  //setupReveal();
  setupRemoveMultiple();
};
