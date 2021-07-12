function monitorDownloadLink() {
  const successNode = document.querySelector('.pdf-success');
  const failureNode = document.querySelector('.pdf-failure');
  const url = successNode.getAttribute('href')
  let http = new XMLHttpRequest();
  http.overrideMimeType("application/pdf");
  http.open('GET', url, true);
  http.onload = function (e) {
    if (http.readyState === 4) {
      if (http.status === 200) {
        failureNode.style.display = 'none';
        successNode.style.display = 'block';
      } else {
        failureNode.style.display = 'block';
        successNode.style.display = 'none';
        console.warn("Unable to find PDF, retrying " + url + " in 10 seconds");
        setTimeout(function() { monitorDownloadLink() }, 10000);
      }
    }
  };
  http.send();
}

export default function ClaimConfirmationPage() {
  monitorDownloadLink();
}
