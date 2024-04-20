import express from "express";
import bodyParser from "body-parser";


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

app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});
