let nav = 0;
let clicked = null;
let events = localStorage.getItem('events') ? JSON.parse(localStorage.getItem('events')) : {};

const calendar = document.getElementById('calendar');
const dayEventsModal = document.getElementById('dayEventsModal');
const newEventModal = document.getElementById('newEventModal');
const backDrop = document.getElementById('modalBackDrop');
const eventTitleInput = document.getElementById('eventTitleInput');
const selectedDate = document.getElementById('selectedDate');
const eventsList = document.getElementById('eventsList');
const weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

function openDayEventsModal(date) {
  clicked = date;
  selectedDate.innerText = clicked;
  eventsList.innerHTML = '';

  const eventForDay = events[clicked];
  if (eventForDay) {
    eventForDay.forEach(event => {
      const eventItem = document.createElement('div');
      eventItem.classList.add('event-item');

      const eventTitle = document.createElement('span');
      eventTitle.classList.add('event-title');
      eventTitle.innerText = event.title;

      const deleteButton = document.createElement('button');
      deleteButton.classList.add('delete-event-button');
      deleteButton.innerText = 'Delete';
      deleteButton.addEventListener('click', () => deleteEvent(event.title));

      eventItem.appendChild(eventTitle);
      eventItem.appendChild(deleteButton);

      eventsList.appendChild(eventItem);
    });
  }

  dayEventsModal.style.display = 'block';
  backDrop.style.display = 'block';
}

function load() {
  const dt = new Date();

  if (nav !== 0) {
    dt.setMonth(new Date().getMonth() + nav);
  }

  const day = dt.getDate();
  const month = dt.getMonth();
  const year = dt.getFullYear();

  const firstDayOfMonth = new Date(year, month, 1);
  const daysInMonth = new Date(year, month + 1, 0).getDate();

  const dateString = firstDayOfMonth.toLocaleDateString('en-us', {
    weekday: 'long',
    year: 'numeric',
    month: 'numeric',
    day: 'numeric',
  });
  const paddingDays = weekdays.indexOf(dateString.split(', ')[0]);

  document.getElementById('monthDisplay').innerText = 
    `${dt.toLocaleDateString('en-us', { month: 'long' })} ${year}`;

  calendar.innerHTML = '';

  for (let i = 1; i <= paddingDays + daysInMonth; i++) {
    const daySquare = document.createElement('div');
    daySquare.classList.add('day');

    const dayString = `${month + 1}/${i - paddingDays}/${year}`;

    if (i > paddingDays) {
      daySquare.innerText = i - paddingDays;

      if (events[dayString]) {
        const eventsToShow = events[dayString].slice(0, 2);
        eventsToShow.forEach(event => {
          const eventDiv = document.createElement('div');
          eventDiv.classList.add('event');
          eventDiv.innerText = event.title;
          daySquare.appendChild(eventDiv);
        });
        if (events[dayString].length > 2) {
          const moreEventsDiv = document.createElement('div');
          moreEventsDiv.classList.add('event');
          moreEventsDiv.innerText = `+ ${events[dayString].length - 2} more`;
          daySquare.appendChild(moreEventsDiv);
        }
      }

      if (i - paddingDays === day && nav === 0) {
        daySquare.id = 'currentDay';
      }

      daySquare.addEventListener('click', () => openDayEventsModal(dayString));
    } else {
      daySquare.classList.add('padding');
    }

    calendar.appendChild(daySquare);    
  }
}

function closeModal() {
  eventTitleInput.classList.remove('error');
  newEventModal.style.display = 'none';
  dayEventsModal.style.display = 'none';
  backDrop.style.display = 'none';
  eventTitleInput.value = '';
  clicked = null;
  load();
}

function saveEvent() {
  if (eventTitleInput.value) {
    eventTitleInput.classList.remove('error');

    if (!events[clicked]) {
      events[clicked] = [];
    }

    events[clicked].push({
      title: eventTitleInput.value,
    });

    localStorage.setItem('events', JSON.stringify(events));
    closeModal();
  } else {
    eventTitleInput.classList.add('error');
  }
}

function deleteEvent(eventTitle) {
  events[clicked] = events[clicked].filter(event => event.title !== eventTitle);
  if (events[clicked].length === 0) {
    delete events[clicked];
  }
  localStorage.setItem('events', JSON.stringify(events));
  openDayEventsModal(clicked);
}

function initButtons() {
  document.getElementById('nextButton').addEventListener('click', () => {
    nav++;
    load();
  });

  document.getElementById('backButton').addEventListener('click', () => {
    nav--;
    load();
  });

  document.getElementById('saveButton').addEventListener('click', saveEvent);
  document.getElementById('cancelButton').addEventListener('click', closeModal);
  document.getElementById('addEventButton').addEventListener('click', () => {
    newEventModal.style.display = 'block';
    dayEventsModal.style.display = 'none';
  });
  document.getElementById('closeDayEventsModal').addEventListener('click', closeModal);
}

initButtons();
load();
