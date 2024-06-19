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
       links: posts_index,
       userID: req.session.userID || null
   });
});

app.post("/login", async (req, res) => {
    const { uname, psw } = req.body;
    req.session.userID = null;
    try {
        let pool = await sql.connect(dbConfig);
        let result = await pool.request()
                        .input('UserUniversityID', sql.Int, uname)
                        .input('UserPassword', sql.NVarChar(255), psw)
                        .output('Result', sql.Int)
                        .execute('UserLogInValidation');

        const loginResult = result.output.Result;
        let message;
        if (loginResult === 0) {
            req.session.userID = uname; // Store the user ID in the session
            message = "Login Successful";
        } else if (loginResult === 1) {
            message = "User does not exist";
        } else if (loginResult === 2) {
            message = "Incorrect password";
        } else {
            message = "Unexpected result";
        }
        res.send(`
            <script>
                alert("${message}");
                window.location.href = "/";
            </script>
        `);
    } catch (err) {
        res.send(`
            <script>
                alert("Failed to connect to the database: ${err.message}");
                window.location.href = "/";
            </script>
        `);
    } finally {
        sql.close();
    }
});
let posts=[];

app.get("/posts", async (req, res) => {
    try {

        if(req.session.userID == null){
           // res.redirect('/');
            //logiin();
        }

        let pool = await sql.connect(dbConfig);
        let result = await pool.request().execute('GetAllPosts');
        posts = result.recordset;
        res.render("posts.ejs", {
            links: posts_posts,
            posts: posts,
            userID: req.session.userID || null
        });
    } catch (err) {
        res.status(500).send("Failed to load posts: " + err.message);
    } finally {
        sql.close();
    }
  });

app.get("/privacy-policy", (req, res) => {
    res.render("rodo.ejs", {
        links: posts_rodo,
        userID: req.session.userID || null
    });
});

  app.post("/submit", async (req,res)=>{
    const { postTitle, content } = req.body;
    const userID = req.session.userID;
    const date = new Date();
    if (!userID) {
        return res.status(401).send("Unauthorized: User not logged in.");
    }
    try {
        let pool = await sql.connect(dbConfig);
        const result = await pool.request()
            .input('UserID', sql.Int, userID)
            .input('Title', sql.NVarChar(50), postTitle)
            .input('Content', sql.NVarChar(1000), content)
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
        /*let result = await pool.request().execute('GetAllPosts');
        posts = result.recordset;
        res.render("posts.ejs", {
            links: posts_index,
            posts: posts,
        });*/
        sql.close();
    }
  });
  

  app.patch('/comment/:id', async (req, res) => {
    const { id } = req.params;
    const { updatedTitle, updatedComment } = req.body;
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
            .input('Title', sql.NVarChar(100), updatedTitle)
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



app.get("/plan", (req, res) => {
   res.render("plan.ejs", {
       links: posts_plan,
       userID: req.session.userID || null
   });
});

app.get("/map", (req, res) => {
   res.render("map.ejs", {
       links: posts_map,
       userID: req.session.userID || null
   });
});


// here handling login procedure
// const sql = require('mssql');

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

//adding events to database 
async function addEvent(userID, calendarID, date, type, title, description) {
    try {
        let pool = await sql.connect(dbConfig);
        let result = await pool.request()
            .input('UserID', sql.Int, userID)
            .input('CalendarID', sql.Int, calendarID)
            .input('Date', sql.DateTimeOffset, date)
            .input('Type', sql.Bit, type)
            .input('Title', sql.NVarChar(30), title)
            .input('Description', sql.NVarChar(100), description)
            .execute('AddEvent');

        console.log(result.recordset[0].Message);
    } catch (err) {
        console.error('SQL error', err);
    } finally {
        sql.close();
    }
}

app.get("/coordinates", async (req, res) => { 
    const { name } = req.query; 
    try { 
        let pool = await sql.connect(dbConfig); 
        let result = await pool.request() 
            .input('Name', sql.NVarChar(255), name) 
            .output('Latitude', sql.Float) 
            .output('Longitude', sql.Float) 
            .execute('GetCoordinates'); 
         
        const latitude = result.output.Latitude; 
        const longitude = result.output.Longitude; 
         
        console.log(`Latitude: ${latitude}, Longitude: ${longitude}`); // Debugging 
        res.status(200).json({ Latitude: latitude, Longitude: longitude }); 
    } catch (err) { 
        console.error("Error fetching coordinates:", err); 
        res.status(500).json({ error: "Failed to retrieve coordinates" }); 
    } finally { 
        sql.close(); 
    } 
 }); 
 
 app.get("/building-names", async (req, res) => {
    try {
        let pool = await sql.connect(dbConfig);
        let result = await pool.request().query('SELECT Name FROM Coordinates');
        res.status(200).json(result.recordset);
    } catch (err) {
        console.error("Error fetching building names:", err);
        res.status(500).json({ error: "Failed to retrieve building names" });
    } finally {
        sql.close();
    }
 });
 

app.listen(port, () => {
   console.log(`Server is running on port ${port}`);
});
