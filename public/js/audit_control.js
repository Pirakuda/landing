const auditData = [
    {
        question: "Какова текущая конверсия вашего сайта в клиентов?",
        subtitle: "Процент посетителей, которые становятся клиентами",
        answers: [
            "Не знаю точно",
            "Менее 5% (низкая эффективность)", 
            "5-15% (средний уровень)",
            "Более 15% (высокая эффективность)"
        ],
        scores: [1, 2, 3, 4],
        problems: ["Отсутствие аналитики конверсии", "Низкая эффективность сайта", null, null]
    },
    {
        question: "Среднее время отклика на заявку с сайта?",
        subtitle: "От получения заявки до первого контакта с клиентом",
        answers: [
            "Более 2 часов", 
            "30-60 минут", 
            "10-30 минут",
            "До 10 минут"
        ],
        scores: [1, 2, 3, 4],
        problems: ["Критически медленный отклик", "Долгое время реакции", "Есть задержки в обработке", null]
    },
    {
        question: "Как часто теряете заявки из соцсетей и порталов?",
        subtitle: "Заявки, которые не обрабатываются или теряются",
        answers: [
            "Регулярно теряем (20%+)", 
            "Иногда теряем (~10%)", 
            "Редко теряем (~5%)",
            "Почти никогда не теряем"
        ],
        scores: [1, 2, 3, 4],
        problems: ["Массовая потеря заявок", "Периодические потери", "Минимальные потери", null]
    },
    {
        question: "Используете ли единую CRM-систему?",
        subtitle: "Централизованная система управления клиентами",
        answers: [
            "Нет, всё ведем вручную", 
            "Частично (Excel + разные системы)", 
            "Да, но базовую",
            "Да, полнофункциональную CRM"
        ],
        scores: [1, 2, 3, 4],
        problems: ["Отсутствие автоматизации", "Разрозненные системы", "Ограниченная функциональность", null]
    },
    {
        question: "Знаете ли точную стоимость привлечения клиента?",
        subtitle: "CAC (Customer Acquisition Cost) по каналам",
        answers: [
            "Не знаем совсем", 
            "Знаем приблизительно", 
            "Знаем по основным каналам",
            "Знаем точно по всем каналам"
        ],
        scores: [1, 2, 3, 4],
        problems: ["Отсутствие аналитики эффективности", "Неточные данные о ROI", "Частичная аналитика", null]
    }
];

let step = 0, totalScore = 0, detectedProblems = [];
const detectorWrap = document.getElementById(`detector-popup-wrap`);
const auditQuestions = detectorWrap.querySelector('#auditQuestions');
const progressFill = detectorWrap.querySelector('#audit-progress-fill');
const currentStep = detectorWrap.querySelector('#audit-current-step');
const auditPrevBtn = detectorWrap.querySelector('#audit-prev-btn');
const auditToCalcBtn = detectorWrap.querySelector('#audit-to-calc-btn');

function updateProgress() {
  const progress = ((step + 1) / auditData.length) * 100;
  progressFill.style.width = progress + '%';
  currentStep.textContent = step + 1;
}

function renderStep() {
    updateProgress();
    updatePrevBtn();
    const q = auditData[step];
    
    let html = `
        <div class="audit-questions-header">
            <div class="audit-question-text">${q.question}</div>
            <div class="audit-question-subtitle">${q.subtitle}</div>
        </div>
        <div class="audit-answers-container">
    `;
    
    q.answers.forEach((ans, idx) => {
        html += `<button class="answerBtn modal-act" data-idx="${idx}">${ans}</button>`;
    });
    
    html += '</div>';
    auditQuestions.innerHTML = html;

    // Добавляем обработчики с анимацией
    const buttons = auditQuestions.querySelectorAll('.answerBtn');
    buttons.forEach((btn, idx) => {
        btn.style.animationDelay = `${idx * 0.1}s`;
        btn.addEventListener('click', () => {
            pickAnswer(parseInt(btn.dataset.idx));
        });
    });
}

function pickAnswer(idx) {
    const q = auditData[step];
    totalScore += q.scores[idx];
    
    // Добавляем проблему если есть
    if (q.problems[idx]) {
        detectedProblems.push(q.problems[idx]);
    }
    
    // Показываем выбранный ответ
    const selectedBtn = document.querySelector(`[data-idx="${idx}"]`);
    selectedBtn.classList.add('selected');
    
    // Переход к следующему вопросу с задержкой
    setTimeout(() => {
        step++;
        if (step < auditData.length) {
            renderStep();
        } else {
            showResult();
        }
    }, 400);
}

function showResult() {
  updateProgress();
  let loss, msg, scoreClass, scoreText;
   
  if (totalScore <= 8) {
      loss = "3 500 000 ₽ в месяц";
      msg = "Критические проблемы с digital-эффективностью! Срочно необходима комплексная автоматизация для предотвращения дальнейших потерь.";
      scoreClass = "score-critical";
      scoreText = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512"><path d="M159.3 5.4c7.8-7.3 19.9-7.2 27.7 .1c27.6 25.9 53.5 53.8 77.7 84c11-14.4 23.5-30.1 37-42.9c7.9-7.4 20.1-7.4 28 .1c34.6 33 63.9 76.6 84.5 118c20.3 40.8 33.8 82.5 33.8 111.9C448 404.2 348.2 512 224 512C98.4 512 0 404.1 0 276.5c0-38.4 17.8-85.3 45.4-131.7C73.3 97.7 112.7 48.6 159.3 5.4zM225.7 416c25.3 0 47.7-7 68.8-21c42.1-29.4 53.4-88.2 28.1-134.4c-4.5-9-16-9.6-22.5-2l-25.2 29.3c-6.6 7.6-18.5 7.4-24.7-.5c-16.5-21-46-58.5-62.8-79.8c-6.3-8-18.3-8.1-24.7-.1c-33.8 42.5-50.8 69.3-50.8 99.4C112 375.4 162.6 416 225.7 416z"/></svg>';
  } else if (totalScore <= 12) {
      loss = "1 800 000 ₽ в месяц";
      msg = "Серьезные потери эффективности. Есть большой потенциал для улучшений через автоматизацию процессов.";
      scoreClass = "score-warning";
      scoreText = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512"><path d="M349.4 44.6c5.9-13.7 1.5-29.7-10.6-38.5s-28.6-8-39.9 1.8l-256 224c-10 8.8-13.6 22.9-8.9 35.3S50.7 288 64 288l111.5 0L98.6 467.4c-5.9 13.7-1.5 29.7 10.6 38.5s28.6 8 39.9-1.8l256-224c10-8.8 13.6-22.9 8.9-35.3s-16.6-20.7-30-20.7l-111.5 0L349.4 44.6z"/></svg>';
  } else if (totalScore <= 16) {
      loss = "800 000 ₽ в месяц";
      msg = "Результат выше среднего, но все еще есть значительные резервы для роста прибыли.";
      scoreClass = "score-good";
      scoreText = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512"><path d="M64 64c0-17.7-14.3-32-32-32S0 46.3 0 64L0 400c0 44.2 35.8 80 80 80l400 0c17.7 0 32-14.3 32-32s-14.3-32-32-32L80 416c-8.8 0-16-7.2-16-16L64 64zm406.6 86.6c12.5-12.5 12.5-32.8 0-45.3s-32.8-12.5-45.3 0L320 210.7l-57.4-57.4c-12.5-12.5-32.8-12.5-45.3 0l-112 112c-12.5 12.5-12.5 32.8 0 45.3s32.8 12.5 45.3 0L240 221.3l57.4 57.4c12.5 12.5 32.8 12.5 45.3 0l128-128z"/></svg>';
  } else {
      loss = "менее 500 000 ₽ в месяц";
      msg = "Отличные показатели! Вы близки к идеалу, можно дополнительно автоматизировать для максимальной эффективности.";
      scoreClass = "score-excellent";
      scoreText = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 576 512"><path d="M400 0L176 0c-26.5 0-48.1 21.8-47.1 48.2c.2 5.3 .4 10.6 .7 15.8L24 64C10.7 64 0 74.7 0 88c0 92.6 33.5 157 78.5 200.7c44.3 43.1 98.3 64.8 138.1 75.8c23.4 6.5 39.4 26 39.4 45.6c0 20.9-17 37.9-37.9 37.9L192 448c-17.7 0-32 14.3-32 32s14.3 32 32 32l192 0c17.7 0 32-14.3 32-32s-14.3-32-32-32l-26.1 0C337 448 320 431 320 410.1c0-19.6 15.9-39.2 39.4-45.6c39.9-11 93.9-32.7 138.2-75.8C542.5 245 576 180.6 576 88c0-13.3-10.7-24-24-24L446.4 64c.3-5.2 .5-10.4 .7-15.8C448.1 21.8 426.5 0 400 0zM48.9 112l84.4 0c9.1 90.1 29.2 150.3 51.9 190.6c-24.9-11-50.8-26.5-73.2-48.3c-32-31.1-58-76-63-142.3zM464.1 254.3c-22.4 21.8-48.3 37.3-73.2 48.3c22.7-40.3 42.8-100.5 51.9-190.6l84.4 0c-5.1 66.3-31.1 111.2-63 142.3z"/></svg>';
  }

  let problemsHtml = '';
  if (detectedProblems.length > 0) {
      problemsHtml = `
          <div class="problems-detected">
              <div class="problems-title">
                  <span>Обнаруженные проблемы:</span>
              </div>
              ${detectedProblems.map(problem => 
                  `<div class="problem-item">${problem}</div>`
              ).join('')}
          </div>
      `;
  }

  auditQuestions.innerHTML = `
      <div class="resultBlock">
          <div class="score-indicator ${scoreClass}">
              ${scoreText}
          </div>
          <div style="color: #eee; font-size: 1.900739vh; font-weight: 600; margin-bottom: 1.0559vh;">
              Оценка ваших потерь:
          </div>
          <div class="loss-amount">${loss}</div>
          <div class="result-message">${msg}</div>
          ${problemsHtml}
      </div>
  `;
}

function updatePrevBtn() {
    auditPrevBtn.disabled = step === 0;
}

// Добавляем обработчик для кнопки
auditPrevBtn.addEventListener('click', () => {
    if (step === 0) return;
    step--;
    renderStep();
});

auditToCalcBtn.addEventListener('click', () => {
    popupList.querySelector('.popup-contr.show')?.classList.remove('show');
    popupList.querySelector('#calc-popup-wrap')?.classList.add('show');
});