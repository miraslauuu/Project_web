import express from "express";
import bodyParser from "body-parser";
import sql from "mssql";

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

const posts_index = [
    {href: '/', id:'home_id',class:'active',text:'Home'},
    {href: '/posts', id:'posts_id',class:'disable',text:'Posts' },
    {href: '/plan', id:'plan_id',class:'disable',text:'Plan' },
    {href: '/map', id:'map_id',class:'disable',text:'Map'},
]
const posts_posts = [
    {href: '/', id:'home_id',class:'disable',text:'Home'},
    {href: '/posts', id:'posts_id',class:'active',text:'Posts' },
    {href: '/plan', id:'plan_id',class:'disable',text:'Plan' },
    {href: '/map', id:'map_id',class:'disable',text:'Map'},
]
const posts_plan = [
    {href: '/', id:'home_id',class:'disable',text:'Home'},
    {href: '/posts', id:'posts_id',class:'disable',text:'Posts' },
    {href: '/plan', id:'plan_id',class:'active',text:'Plan' },
    {href: '/map', id:'map_id',class:'disable',text:'Map'},
]
const posts_map = [
    {href: '/', id:'home_id',class:'disable',text:'Home'},
    {href: '/posts', id:'posts_id',class:'disable',text:'Posts' },
    {href: '/plan', id:'plan_id',class:'disable',text:'Plan' },
    {href: '/map', id:'map_id',class:'active',text:'Map'},
]
app.get("/", (req, res) => {
    res.render("index.ejs", {
        links: posts_index
    });
});

app.get("/posts", (req, res) => {
    res.render("posts.ejs", {
        links: posts_posts
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

app.get("/login", (req, res) => {
    res.render("login.ejs", {
        links: posts_map
    });
});



//here handling login procedure
//const sql = require('mssql');

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


app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});
