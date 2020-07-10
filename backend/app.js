// Création de l'application
const app = require('express')();

const bodyParser = require('body-parser');
const cors = require('cors');

// Référencement des middlewares
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Référencement des routes
app.use(require('./routes'));

// Lancement du serveur
app.listen(3002, () => console.log('server started'));
