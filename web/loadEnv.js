function addMapsApiKeyScript() {
    var s = document.createElement('script');
    s.setAttribute('src', "https://maps.googleapis.com/maps/api/js?key=" + process.env.MAPS_API_KEY);
    document.body.appendChild(s);
}