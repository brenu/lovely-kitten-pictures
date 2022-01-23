<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Comfortaa:wght@300;400;500;600;700&family=Orbitron&family=Ubuntu:wght@300;400;500;700&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="styles.css" />
    <title>Lovely Kitten Pictures</title>
</head>
<body>
    <div id="main-container">
        <div id="content">
            <h1>🐈 Lovely Kitten Pictures 🐈</h1>
            <div id="picture-container">
                <img />
                <div class="heart"></div>
                <div class="heart heart-reverse"></div>
                <div class="heart"></div>
                <div class="heart heart-reverse"></div>
            </div>
            <span></span>
            <button onclick="changeKitten()">Switch</button>
        </div>
    </div>
    <script>
        let kitten = 0;

        changeKitten();

        function changeKitten() {
            kitten = getRandomInt(1,11, kitten);

            fetch(`cat_info.php?id=${kitten}`)
                .then(async (response) => {
                    let result = await response.json();
                    result = JSON.parse(result);

                    const picture = document.getElementsByTagName("img")[0];
                    picture.src = `pictures.php?path=${result.Picture}`;
                    
                    picture.onload = (event) => {
                        event.target.style.boxShadow = "0px 0px 5px 5px rgba(0,0,0,0.2)";
                    };

                    const span = document.getElementsByTagName("span")[0];
                    span.innerText = result.Name;
                });
        }

        function getRandomInt(min, max, except) {
            min = Math.ceil(min);
            max = Math.floor(max);

            let result = Math.floor(Math.random() * (max - min)) + min;

            while (result === except) {
                result = Math.floor(Math.random() * (max - min)) + min;
            }

            return result;
        }

    </script>
</body>
</html>