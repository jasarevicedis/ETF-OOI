using Pkg
Pkg.add("Blink")
using Blink


function calculate_sum(num1::Int, num2::Int)
    return num1 + num2
end


function zbir_razlika_gui()
    window = Blink.Window()

    html_content = """
    <html>
        <head>
            <title>Zbir razlika GUI</title>
            <style>
                body { font-family: Arial, sans-serif; padding: 20px; }
                input { margin: 5px; }
            </style>
        </head>
        <body>
            <h1>Zbir razlika GUI</h1>
            <input id="num1" type="number" placeholder="Unesite prvi broj" />
            <input id="num2" type="number" placeholder="Unesite drugi broj" />
            <button id="addBtn">Racunaj</button>
            <h2 id="result"></h2>
            <script>
                // Set up message passing from Julia
                document.getElementById("addBtn").onclick = function() {
                    const num1 = parseInt(document.getElementById("num1").value);
                    const num2 = parseInt(document.getElementById("num2").value);
                    
                }
            </script>
        </body>
    </html>
    """

    Blink.body!(window, html_content)

    Blink.show(window)
end

zbir_razlika_gui()

# NE RADIIIIIIIIIII
