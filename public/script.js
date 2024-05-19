const form_container=document.querySelector('.form_container');
const loginLink=document.querySelector('.login-l');
const registerLink=document.querySelector('.register-l');
const btnPopup=document.querySelector('.login');
const btnPopup2=document.querySelector('.login_dropdown');
const iconClose=document.querySelector('.form_close');
const loginSection= document.querySelector('.login_section');

const toggle_button=document.querySelector('.toggle_btn');
const xmark_button=document.querySelector('.xmark_btn');
const drop_down_menu=document.querySelector('.dropdown_menu');
const body=document.querySelector('html');

registerLink.addEventListener('click',()=>{
    form_container.classList.add('active');
});
loginLink.addEventListener('click',()=>{
    form_container.classList.remove('active');
});
btnPopup.addEventListener('click',()=>{
    form_container.classList.add('active-popup');
    form_container.classList.remove('active');
    loginSection.style.position="fixed";
    loginSection.style.zIndex = "101";
});
btnPopup2.addEventListener('click',()=>{
    form_container.classList.add('active-popup');
    form_container.classList.remove('active');
    loginSection.style.position="fixed";
    loginSection.style.zIndex = "101";
    drop_down_menu.classList.remove("open");
});
iconClose.addEventListener('click',()=>{
    form_container.classList.remove('active-popup');
    loginSection.style.position="absolute";
    loginSection.style.zIndex = "";
});
 // =====================code for dropdown=============================

 toggle_button.onclick=function(){
     drop_down_menu.classList.toggle("open");
 };
 xmark_button.onclick=function(){
     drop_down_menu.classList.remove("open");
 };
 //---------------------------Posts-------------------------------------
 // Get modal element
const modal = document.getElementById("postModal");
const textarea = document.getElementById("postTextarea");
const closeBtn = document.querySelector(".close");
const postForm = document.getElementById("postForm");

// Open modal when textarea is clicked
textarea.addEventListener("click", () => {
    modal.style.display = "block";
});

// Close modal when the close button is clicked
closeBtn.addEventListener("click", () => {
    modal.style.display = "none";
});

// Close modal when clicking outside of modal content
window.addEventListener("click", (event) => {
    if (event.target == modal) {
        modal.style.display = "none";
    }
});

// Optional: Handle form submission for client-side validation or other actions before submission
postForm.addEventListener("submit", (event) => {
    // Example: Validate form before submitting
    const title = document.getElementById("postTitle").value;
    const content = document.getElementById("postContent").value;
    
    if (!title || !content) {
        event.preventDefault(); // Prevent form submission
        alert("Please fill in both the title and content.");
    }
});
