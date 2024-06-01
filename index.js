import express from "express";
import bodyParser from "body-parser";
import methodOverride from "method-override";
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
app.use(methodOverride('_method'));
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
const posts_rodo = [
    {href: '/', id:'home_id',class:'disable',text:'Home'},
    {href: '/posts', id:'posts_id',class:'disable',text:'Posts' },
    {href: '/plan', id:'plan_id',class:'disable',text:'Plan' },
    {href: '/map', id:'map_id',class:'disable',text:'Map'},
]
app.get("/", (req, res) => {
    res.render("index.ejs", {
        links: posts_index
    });
});
let posts=[];

app.get("/posts", (req, res) => {
    res.render("posts.ejs", {
      links: posts_posts,
      posts: posts,
    });
  });
  app.get("/privacy-policy", (req, res) => {
    res.render("rodo.ejs", {
        links: posts_rodo
    });
});

  app.post("/submit",(req,res)=>{
    const date = new Date().toLocaleString();
    const postTitle=req.body.postTitle;
    const newPost = {
        title: postTitle,
        date: date
      };
    posts.unshift(newPost);
    res.redirect("/posts");
  });
  app.patch('/comment/:id', (req, res) => {
    const { id } = req.params;
    const { updatedComment } = req.body;
    posts[id].title = updatedComment; 
    res.redirect("/posts");
  });
  app.delete('/comment/:id', (req, res) => {
    const { id } = req.params;
    posts.splice(id, 1);
    res.redirect("/posts");
  });
  
// app.get("/posts", async (req, res) => {
//     try {
//         let pool = await sql.connect(dbConfig);
//         let result = await pool.request().query('SELECT PostID, UserID, Title, Content, Date FROM Posts ORDER BY Date DESC');
//         const posts = result.recordset;
//         res.render("posts.ejs", {
//             links: posts_posts,
//             posts: posts
//         });
//     } catch (err) {
//         res.status(500).send("Failed to fetch posts: " + err.message);
//     } finally {
//         sql.close();
//     }
// });


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
// app.post("/submit", async (req, res) => {
//     const { title, text } = req.body;
//     const userID = 1; // assuming a logged-in user with ID 1 for simplicity
//     try {
//         let pool = await sql.connect(dbConfig);
//         await pool.request()
//             .input('UserID', sql.Int, userID)
//             .input('Title', sql.NVarChar(50), title)
//             .input('Content', sql.NVarChar(1000), text)
//             .query('INSERT INTO Posts (UserID, Title, Content) VALUES (@UserID, @Title, @Content)');
//         res.redirect("/posts");
//     } catch (err) {
//         res.status(500).send("Failed to submit post: " + err.message);
//     } finally {
//         sql.close();
//     }
// });

// app.patch('/comment/:id', async (req, res) => {
//     const { id } = req.params;
//     const { updatedComment } = req.body;
//     try {
//         let pool = await sql.connect(dbConfig);
//         await pool.request()
//             .input('PostID', sql.Int, id)
//             .input('Content', sql.NVarChar(1000), updatedComment)
//             .query('UPDATE Posts SET Content = @Content WHERE PostID = @PostID');
//         res.redirect("/posts");
//     } catch (err) {
//         res.status(500).send("Failed to update post: " + err.message);
//     } finally {
//         sql.close();
//     }
// });

// app.delete('/comment/:id', async (req, res) => {
//     const { id } = req.params;
//     try {
//         let pool = await sql.connect(dbConfig);
//         await pool.request()
//             .input('PostID', sql.Int, id)
//             .query('DELETE FROM Posts WHERE PostID = @PostID');
//         res.redirect("/posts");
//     } catch (err) {
//         res.status(500).send("Failed to delete post: " + err.message);
//     } finally {
//         sql.close();
//     }
// });


// here handling login procedure
// const sql = require('mssql');

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

// registration proces handling
app.post("/register", async (req, res) => {
    const { UserUniversityID, UserFirstName, UserLastName, UserPassword } = req.body;
    let pool;

    try {
        pool = await sql.connect(dbConfig); // Connect to the database
        let result = await pool.request()
            .input("UserUniversityID", sql.Int, UserUniversityID)
            .input("UserFirstName", sql.NVarChar(30), UserFirstName)
            .input("UserLastName", sql.NVarChar(30), UserLastName)
            .input("UserPassword", sql.NVarChar(255), UserPassword)
            .output("Result", sql.Int)
            .execute("UserRegistration"); // Execute the stored procedure
        
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
            pool.close(); // Close the database connection
        }
    }
});


app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});
