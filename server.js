const app = require('./index')
const port = 5000

app.listen(port, () => {
    console.log(`Server is running on Port ${port}`)
})