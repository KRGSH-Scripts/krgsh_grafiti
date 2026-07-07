window.addEventListener('message', function(event) {
    const data = event.data;
    
    if (data.action === 'showGraffiti') {
        showGraffiti(data.url);
    }
});

function showGraffiti(url) {
    const container = document.getElementById('graffiti-container');
    container.innerHTML = `<img src="${url}" style="width: 100%; height: auto;">`;
}