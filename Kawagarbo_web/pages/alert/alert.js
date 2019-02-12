
function goback() {
    // history.back(-1)
    location.href = document.referrer
}

function showAlert() {
    alert('alert text')
}

function showConfirm() {
    confirm('confirm text')
}

function showPrompt() {
    prompt('prompt text', 'placeholder')
}
