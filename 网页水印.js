        const setWatermark = () => {
            let canvas = document.createElement('canvas');
            canvas.width = 120;
            canvas.height = 80;
            canvas.style.border = '1px solid red';
            let ctx = canvas.getContext('2d');
            ctx.rotate(-30 * Math.PI / 180);
            ctx.font = '15px Vedana';
            ctx.fillStyle = '#000'
            ctx.fillText('这是一个水印', 10, 70);
            let div = document.createElement('div');
            div.style.pointerEvents = 'none';
            div.style.top = '0px';
            div.style.left = '0px';
            div.style.opacity = '0.2';
            div.style.position = 'fixed';
            div.style.width = document.documentElement.clientWidth + 'px';
            div.style.height = document.documentElement.clientHeight + 'px';
            div.style.background = 'url(' + canvas.toDataURL('image/png') + ') left top repeat';
            let docFragments = document.createDocumentFragment();
            docFragments.appendChild(div);
            document.body.appendChild(docFragments);
        }
