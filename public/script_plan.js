let nav = 0;
let clicked = null;
let events = localStorage.getItem('events') ? JSON.parse(localStorage.getItem('events')) : {};

const calendar = document.getElementById('calendar');
const dayEventsModal = document.getElementById('dayEventsModal');
const newEventModal = document.getElementById('newEventModal');
const eventDetailsModal = document.getElementById('eventDetailsModal');
const backDrop = document.getElementById('modalBackDrop');
const eventTitleInput = document.getElementById('eventTitleInput');
const eventStartTimeInput = document.getElementById('eventStartTimeInput');
const eventEndTimeInput = document.getElementById('eventEndTimeInput');
const eventDescriptionInput = document.getElementById('eventDescriptionInput');
const selectedDate = document.getElementById('selectedDate');
const eventsList = document.getElementById('eventsList');
const eventDetailsTitle = document.getElementById('eventDetailsTitle');
const eventDetailsTime = document.getElementById('eventDetailsTime');
const eventDetailsDescription = document.getElementById('eventDetailsDescription');
const weekdays = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

const monthlyViewButton = document.getElementById('monthlyViewButton');
const weeklyViewButton = document.getElementById('weeklyViewButton');

document.getElementById('monthlyViewButton').addEventListener('click', () => {
    setActiveButton(monthlyViewButton);
    loadMonthlyView();
});

document.getElementById('weeklyViewButton').addEventListener('click', () => {
    setActiveButton(weeklyViewButton);
    loadWeeklyView();
});

function setActiveButton(button) {
    monthlyViewButton.classList.remove('active');
    weeklyViewButton.classList.remove('active');
    button.classList.add('active');
}

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

            const detailsButton = document.createElement('button');
            detailsButton.classList.add('details-event-button');
            detailsButton.innerText = 'Details';
            detailsButton.addEventListener('click', () => showEventDetails(event));

            const deleteButton = document.createElement('button');
            deleteButton.classList.add('delete-event-button');
            deleteButton.innerText = 'Delete';
            deleteButton.addEventListener('click', () => deleteEvent(event.title));

            eventItem.appendChild(eventTitle);
            eventItem.appendChild(detailsButton);
            eventItem.appendChild(deleteButton);

            eventsList.appendChild(eventItem);
        });
    }

    dayEventsModal.style.display = 'block';
    backDrop.style.display = 'block';
}

function showEventDetails(event) {
    eventDetailsTitle.innerText = event.title;
    eventDetailsTime.innerHTML = `<span>${clicked}</span><span>${event.startTime} - ${event.endTime}</span>`;
    eventDetailsDescription.innerText = event.description;
    dayEventsModal.style.display = 'none';
    eventDetailsModal.style.display = 'block';
}

function loadMonthlyView() {
    const dt = new Date();

    if (nav !== 0) {
        dt.setMonth(new Date().getMonth() + nav);
    }

    const day = dt.getDate();
    const month = dt.getMonth();
    const year = dt.getFullYear();

    const firstDayOfMonth = new Date(year, month, 1);
    const daysInMonth = new Date(year, month + 1, 0).getDate();
    const daysInPreviousMonth = new Date(year, month, 0).getDate();

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

    for (let i = paddingDays; i > 0; i--) {
        const daySquare = document.createElement('div');
        daySquare.classList.add('day', 'prev-month-day');

        const dayString = `${month === 0 ? 12 : month}/${daysInPreviousMonth - i + 1}/${month === 0 ? year - 1 : year}`;

        daySquare.innerText = daysInPreviousMonth - i + 1;

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

        daySquare.addEventListener('click', () => openDayEventsModal(dayString));
        calendar.appendChild(daySquare);
    }

    for (let i = 1; i <= daysInMonth; i++) {
        const daySquare = document.createElement('div');
        daySquare.classList.add('day');

        const dayString = `${month + 1}/${i}/${year}`;

        daySquare.innerText = i;

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

        if (i === day && nav === 0) {
            daySquare.id = 'currentDay';
        }

        daySquare.addEventListener('click', () => openDayEventsModal(dayString));
        calendar.appendChild(daySquare);
    }

    const totalSquares = paddingDays + daysInMonth;
    const nextDays = (totalSquares % 7 === 0) ? 0 : (7 - (totalSquares % 7));
    const totalDays = totalSquares + nextDays;
    const remainingDays = (totalDays > 35) ? 42 - totalSquares : 35 - totalSquares;

    for (let i = 1; i <= remainingDays; i++) {
        const daySquare = document.createElement('div');
        daySquare.classList.add('day', 'next-month-day');

        const dayString = `${month + 2 > 12 ? 1 : month + 2}/${i}/${month + 2 > 12 ? year + 1 : year}`;

        daySquare.innerText = i;

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

        daySquare.addEventListener('click', () => openDayEventsModal(dayString));
        calendar.appendChild(daySquare);
    }
}

function loadWeeklyView() {
    const dt = new Date();

    const currentDayOfWeek = dt.getDay();
    const currentDate = dt.getDate();
    const currentMonth = dt.getMonth();
    const currentYear = dt.getFullYear();

    const startOfWeek = new Date(currentYear, currentMonth, currentDate - currentDayOfWeek);
    const endOfWeek = new Date(currentYear, currentMonth, currentDate + (6 - currentDayOfWeek));

    document.getElementById('monthDisplay').innerText = 
        `${startOfWeek.toLocaleDateString('en-us', { month: 'short', day: 'numeric' })} - ${endOfWeek.toLocaleDateString('en-us', { month: 'short', day: 'numeric' })}`;

    calendar.innerHTML = '';

    for (let i = 0; i < 7; i++) {
        const daySquare = document.createElement('div');
        daySquare.classList.add('day');

        const dayDate = new Date(startOfWeek);
        dayDate.setDate(startOfWeek.getDate() + i);
        const dayString = `${dayDate.getMonth() + 1}/${dayDate.getDate()}/${dayDate.getFullYear()}`;

        daySquare.innerText = dayDate.getDate();

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

        if (i === currentDayOfWeek && nav === 0) {
            daySquare.id = 'currentDay';
        }

        daySquare.addEventListener('click', () => openDayEventsModal(dayString));

        calendar.appendChild(daySquare);
    }
}

function closeModal() {
    eventTitleInput.classList.remove('error');
    eventStartTimeInput.classList.remove('error');
    eventEndTimeInput.classList.remove('error');
    eventDescriptionInput.classList.remove('error');
    newEventModal.style.display = 'none';
    dayEventsModal.style.display = 'none';
    eventDetailsModal.style.display = 'none';
    backDrop.style.display = 'none';
    eventTitleInput.value = '';
    eventStartTimeInput.value = '';
    eventEndTimeInput.value = '';
    eventDescriptionInput.value = '';
    clicked = null;
    loadMonthlyView();
}

function saveEvent() {
    if (eventTitleInput.value && eventStartTimeInput.value && eventEndTimeInput.value && eventDescriptionInput.value) {
        eventTitleInput.classList.remove('error');
        eventStartTimeInput.classList.remove('error');
        eventEndTimeInput.classList.remove('error');
        eventDescriptionInput.classList.remove('error');

        if (!events[clicked]) {
            events[clicked] = [];
        }

        events[clicked].push({
            title: eventTitleInput.value,
            startTime: eventStartTimeInput.value,
            endTime: eventEndTimeInput.value,
            description: eventDescriptionInput.value
        });

        localStorage.setItem('events', JSON.stringify(events));
        closeModal();
    } else {
        if (!eventTitleInput.value) {
            eventTitleInput.classList.add('error');
        }
        if (!eventStartTimeInput.value) {
            eventStartTimeInput.classList.add('error');
        }
        if (!eventEndTimeInput.value) {
            eventEndTimeInput.classList.add('error');
        }
        if (!eventDescriptionInput.value) {
            eventDescriptionInput.classList.add('error');
        }
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
        loadMonthlyView();
    });

    document.getElementById('backButton').addEventListener('click', () => {
        nav--;
        loadMonthlyView();
    });

    document.getElementById('saveButton').addEventListener('click', saveEvent);
    document.getElementById('cancelButton').addEventListener('click', closeModal);
    document.getElementById('addEventButton').addEventListener('click', () => {
        newEventModal.style.display = 'block';
        dayEventsModal.style.display = 'none';
        backDrop.style.display = 'block';
    });
    document.getElementById('closeDayEventsModal').addEventListener('click', closeModal);
    document.getElementById('closeEventDetailsModal').addEventListener('click', () => {
        eventDetailsModal.style.display = 'none';
        dayEventsModal.style.display = 'block';
    });
}

initButtons();
setActiveButton(monthlyViewButton);
loadMonthlyView();
