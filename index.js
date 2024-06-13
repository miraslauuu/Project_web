import express from "express";
import bodyParser from "body-parser";
import methodOverride from "method-override";
import sql from "mssql";
import session from "express-session";

const dbConfig = {
    server: "LAPTOP-BJSNAIAH",
    database: "SVO_DB_PROJECT_FINAL_VERSION",
    user: "anhelina",
    password: "Hfge!0406",
    options: {
        encrypt: false,
        enableArithAbort: true
    }
};

const app = express();
const port = 3000;

app.use(express.static("public"));
app.use(bodyParser.urlencoded({ extended: true }));
app.use(methodOverride('_method'));
app.use(bodyParser.json());

// Konfiguracja sesji
app.use(session({
    secret: 'your_secret_key', // Użyj silnego klucza sekretu
    resave: false,
    saveUninitialized: false,
    cookie: { secure: false } // Ustaw na true, jeśli używasz HTTPS
}));

const posts_index = [
    { href: '/', id: 'home_id', class: 'active', text: 'Home' },
    { href: '/posts', id: 'posts_id', class: 'disable', text: 'Posts' },
    { href: '/plan', id: 'plan_id', class: 'disable', text: 'Plan' },
    { href: '/map', id: 'map_id', class: 'disable', text: 'Map' },
];
const posts_posts = [
    { href: '/', id: 'home_id', class: 'disable', text: 'Home' },
    { href: '/posts', id: 'posts_id', class: 'active', text: 'Posts' },
    { href: '/plan', id: 'plan_id', class: 'disable', text: 'Plan' },
    { href: '/map', id: 'map_id', class: 'disable', text: 'Map' },
];
const posts_plan = [
    { href: '/', id: 'home_id', class: 'disable', text: 'Home' },
    { href: '/posts', id: 'posts_id', class: 'disable', text: 'Posts' },
    { href: '/plan', id: 'plan_id', class: 'active', text: 'Plan' },
    { href: '/map', id: 'map_id', class: 'disable', text: 'Map' },
];
const posts_map = [
    { href: '/', id: 'home_id', class: 'disable', text: 'Home' },
    { href: '/posts', id: 'posts_id', class: 'disable', text: 'Posts' },
    { href: '/plan', id: 'plan_id', class: 'disable', text: 'Plan' },
    { href: '/map', id: 'map_id', class: 'active', text: 'Map' },
];

app.get("/", (req, res) => {
    res.render("index.ejs", {
        links: posts_index
    });
});

let posts = [];

app.get("/posts", (req, res) => {
    res.render("posts.ejs", {
        links: posts_posts,
        posts: posts
    });
});

app.get("/plan", (req, res) => {
    res.render("plan.ejs", {
        links: posts_plan
    });
});

app.get("/map", (req, res) => {
    res.render("map.ejs", {
        links: posts_map
    });
});

app.post("/submit", async (req, res) => {
    const { title, text } = req.body;
    const userID = req.session.userID;
    const date = new Date();
    if (!userID) {
        return res.status(401).send("Unauthorized: User not logged in.");
    }
    try {
        let pool = await sql.connect(dbConfig);
        const result = await pool.request()
            .input('UserID', sql.Int, userID)
            .input('Title', sql.NVarChar(50), title)
            .input('Content', sql.NVarChar(1000), text)
            .input('Date', sql.DateTimeOffset, date)
            .output('Result', sql.Int)
            .execute('AddPost');

        const resultCode = result.output.Result;
        if (resultCode === 0) {
            res.redirect("/posts");
        } else if (resultCode === 2) {
            res.status(400).send("Unsafe input detected.");
        } else {
            res.status(500).send("Failed to submit post.");
        }
    } catch (err) {
        res.status(500).send("Failed to submit post: " + err.message);
    } finally {
        sql.close();
    }
});

app.patch('/comment/:id', async (req, res) => {
    const { id } = req.params;
    const { updatedComment } = req.body;
    const userID = req.session.userID;
    const date = new Date();
    if (!userID) {
        return res.status(401).send("Unauthorized: User not logged in.");
    }
    try {
        let pool = await sql.connect(dbConfig);
        const result = await pool.request()
            .input('PostID', sql.Int, id)
            .input('UserID', sql.Int, userID)
            .input('Content', sql.NVarChar(1000), updatedComment)
            .input('Date', sql.DateTimeOffset, date)
            .output('Result', sql.Int)
            .execute('UpdatePost');

        const resultCode = result.output.Result;
        if (resultCode === 0) {
            res.redirect("/posts");
        } else if (resultCode === 2) {
            res.status(400).send("Unsafe input detected.");
        } else if (resultCode === 1) {
            res.status(404).send("Post not found or you are not the author.");
        } else {
            res.status(500).send("Failed to update post.");
        }
    } catch (err) {
        res.status(500).send("Failed to update post: " + err.message);
    } finally {
        sql.close();
    }
});

app.delete('/comment/:id', async (req, res) => {
    const { id } = req.params;
    const userID = req.session.userID;
    if (!userID) {
        return res.status(401).send("Unauthorized: User not logged in.");
    }
    try {
        let pool = await sql.connect(dbConfig);
        const result = await pool.request()
            .input('PostID', sql.Int, id)
            .input('UserID', sql.Int, userID)
            .output('Result', sql.Int)
            .execute('DeletePost');

        const resultCode = result.output.Result;
        if (resultCode === 0) {
            res.redirect("/posts");
        } else if (resultCode === 1) {
            res.status(404).send("Post not found or you are not the author.");
        } else {
            res.status(500).send("Failed to delete post.");
        }
    } catch (err) {
        res.status(500).send("Failed to delete post: " + err.message);
    } finally {
        sql.close();
    }
});

app.post("/login", async (req, res) => {
    const { uname, psw } = req.body;
    try {
        let pool = await sql.connect(dbConfig);
        let result = await pool.request()
            .input('UserUniversityID', sql.Int, uname)
            .input('UserPassword', sql.NVarChar(255), psw)
            .output('Result', sql.Int)
            .execute('UserLogInValidation');

        const loginResult = result.output.Result;
        if (loginResult === 0) {
            req.session.userID = uname; // Ustaw UserID w sesji
            res.send("Login Successful");
        } else if (loginResult === 1) {
            res.send("User does not exist");
        } else if (loginResult === 2) {
            res.send("Incorrect password");
        } else {
            res.send("Unexpected result");
        }
    } catch (err) {
        res.status(500).send("Failed to connect to the database: " + err.message);
    } finally {
        sql.close();
    }
});

app.post("/register", async (req, res) => {
    const { UserUniversityID, UserFirstName, UserLastName, UserPassword } = req.body;
    let pool;

    try {
        pool = await sql.connect(dbConfig);
        let result = await pool.request()
            .input("UserUniversityID", sql.Int, UserUniversityID)
            .input("UserFirstName", sql.NVarChar(30), UserFirstName)
            .input("UserLastName", sql.NVarChar(30), UserLastName)
            .input("UserPassword", sql.NVarChar(255), UserPassword)
            .output("Result", sql.Int)
            .execute("UserRegistration");

        const registrationResult = result.output.Result;
        if (registrationResult === 0) {
            res.send("Registration successful!");
        } else if (registrationResult === 1) {
            res.send("User already exists");
        } else if (registrationResult === 2) {
            res.send("Registration failed");
        } else {
            res.send("Unexpected error occurred");
        }
    } catch (err) {
        res.status(500).send("Failed to register user: " + err.message);
    } finally {
        if (pool) {
            pool.close();
        }
    }
});

app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});
