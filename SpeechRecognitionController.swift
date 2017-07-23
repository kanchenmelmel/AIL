//
//  SpeechRecognitionVC.swift
//  AIL
//
//  Created by Wenyu Zhao on 16/2/17.
//  Copyright © 2017 au.com.melmel. All rights reserved.
//

import UIKit
import SpeechToTextV1
//import EZAudio

func adjust(x: Double) -> Double {
    if x < 0 { return 0 }
    if x > 1 { return 1 }
    return pow(x, 1.0/2.5)//sqrt(-x * x + 2 * x)
}

class SpeechRecognitionController: UIViewController {

    @IBOutlet weak var originalTextView: UITextView!
    @IBOutlet weak var recognizedTextView: UITextView!
    @IBOutlet weak var recognizeButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    
    let speechToText = SpeechToText(username: "619904ee-6747-4e6b-9976-bdc002d9d433", password: "C3mWO3hzjFmX")
    var text: String = ""
    
    
    func editDistance(_ s: [String], _ t: [String]) -> Int {
        var table = Array<Array<Int>>(repeating: Array<Int>(repeating: 0, count: t.count + 1), count: s.count + 1)
        for i in 1..<(s.count + 1) {
            table[i][0] = i
        }
        for i in 1..<(t.count + 1) {
            table[0][i] = i
        }
        for i in 1..<(s.count + 1) {
            for j in 1..<(t.count + 1) {
                if s[i - 1] == t[j - 1] {
                    table[i][j] = table[i - 1][j - 1]
                } else {
                    table[i][j] = 1 + min(table[i - 1][j], table[i][j - 1], table[i - 1][j - 1])
                }
            }
        }
        return table[s.count][t.count]
    }
    
    func tokenize(_ text: String) -> [String] {
        return text
            .components(separatedBy: " ")
            .filter { token in
                let regex = try! NSRegularExpression(pattern: "^[0-9a-zA-Z]+$")
                let res = regex.matches(in: token, range: NSMakeRange(0, token.characters.count))
                return res.count > 0
            }
            .map { token in
                return token.lowercased()
            }
    }

    func updateResult(transcript: String, recognitionResults results: [SpeechRecognitionResult], final: Bool = false) {
        let charsCount = transcript.characters.count
        let confidence = results.reduce(0.0) { _confidence, item in
            if item.alternatives.count > 0 && item.alternatives[0].confidence != nil {
                let weight = Double(item.alternatives[0].transcript.characters.count) / Double(charsCount)
                let weightedPartialConfidence = item.alternatives[0].confidence! * weight
                let __confidence = _confidence + weightedPartialConfidence
                if __confidence >= 1.0 {
                    return 1.0 - Double.ulpOfOne
                } else if __confidence <= 0 {
                    return Double.ulpOfOne
                } else {
                    return __confidence
                }
            } else {
                return _confidence
            }
        }
        
        let (s, t) = (tokenize(text), tokenize(transcript))
        let maxLength = max(s.count, t.count)
        var accuracy = 0.0
        
        if final {
            accuracy = 1.0 - Double(editDistance(s, t)) / Double(maxLength)
        } else {
            let minLength = min(s.count, t.count)
            let difference = maxLength - minLength
            accuracy = Double(minLength - editDistance(s, t) + difference) / Double(minLength)
        }
        
        
        let string = "👂: " + transcript
        let attrString = NSMutableAttributedString(string: string)

        for result in results {
            if result.alternatives.count > 0 && result.alternatives[0].confidence != nil {
                let range = (string as NSString).range(of: result.alternatives[0].transcript)
                let alpha = CGFloat(result.alternatives[0].confidence!)
                attrString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 0, green: 0, blue: 0, alpha: alpha), range: range)
            }
        }
        attrString.addAttributes([ NSFontAttributeName: UIFont.systemFont(ofSize: 16) ], range: NSMakeRange(0, attrString.length))
        
        self.recognizedTextView.attributedText = attrString
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        formatter.roundingMode = .up

        let score = formatter.string(from: (adjust(x: confidence * accuracy) * (100.0 as Double)) as NSNumber)
        self.scoreLabel.text = "得分: \(score!)/100"
    }

    var lastResult: SpeechRecognitionResults? = nil
    func startStreaming() {
        var settings = RecognitionSettings(contentType: .opus)
        settings.maxAlternatives = 1
        settings.inactivityTimeout = -1
        settings.continuous = true
        settings.interimResults = true
        
        speechToText.recognizeMicrophone(settings: settings, failure: { print($0) }) { results in
            self.lastResult = results
            self.updateResult(transcript: results.bestTranscript, recognitionResults: results.results)
        }
    }

    func stopStreaming() {
        print("stopped")
        speechToText.stopRecognizeMicrophone()
    }
    
    func stopRecognizing() {
        self.stopStreaming()
        self.isRecognizing = false
            
        self.recognizeButton.setTitleColor(.tintColor(), for: .normal)
        self.recognizeButton.setTitle("开始朗读", for: .normal)
            
        if self.lastResult != nil {
            self.updateResult(transcript: lastResult!.bestTranscript, recognitionResults: lastResult!.results, final: true)
        }
    }
    
    func startRecognizing() {
        self.recognizedTextView.text = "👂: "
        self.startStreaming()
        self.isRecognizing = true
        self.recognizeButton.setTitleColor(.green, for: .normal)
        self.recognizeButton.setTitle("朗读完毕", for: .normal)
        print("start recognizing")
    }
    
    var count = 3
    func countDown3(timer: Timer) {
        if self.count == 0 {
            timer.invalidate()
            self.startRecognizing()
            return
        }
        self.recognizeButton.setTitle("\(count)", for: .normal)
        count -= 1
    }
    
    var isRecognizing = false
    func handleRecognizeButtonPress(_ sender:UIButton!) {
        if self.isRecognizing {
            self.stopRecognizing()
        } else {
            self.count = 3
            Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown3), userInfo: nil, repeats: true)
            //self.startRecognizing()
        }
    }
    
    func initialize() {
        if self.isRecognizing {
            self.stopRecognizing()
        }
        
        self.text = SpeechRecognitionTestData[Int(arc4random_uniform(UInt32(SpeechRecognitionTestData.count)))]
        self.originalTextView.text = "📃: " + text
        self.recognizedTextView.text = "👂: "
        //waveView!.setupPlot()
    }
    
    override func viewDidLoad() {
        self.navigationItem.title = "AIL发音测试"
        
        let changeSentenceButton = UIBarButtonItem(title: "换题", style: .plain, target: self, action: #selector(SpeechRecognitionController.initialize))
        /*let changeSentenceButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(SpeechRecognitionController.initialize))*/
        self.navigationItem.rightBarButtonItems = [ changeSentenceButton ]

    
        self.initialize()
        
        self.recognizeButton.setTitleColor(.tintColor(), for: .normal)
        recognizeButton.addTarget(self, action: #selector(SpeechRecognitionController.handleRecognizeButtonPress(_:)), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.originalTextView.contentInset = UIEdgeInsetsMake(-7.0, 0.0, 0, 0.0);
        self.recognizedTextView.font = UIFont.systemFont(ofSize: 16)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.stopRecognizing()
    }
}




let SpeechRecognitionTestData = [
    "Once you’ve picked a general topic for your paper, you need to come up with a thesis. Your thesis is the main focal point of your paper and it’s the position you’ll take on your particular topic. Formulating a strong thesis is one of the most important things you need to do to ace your paper.",

    "Many papers you write in college will require you to include quotes from one or more sources. Even if you don’t have to do it, integrating a few quotes into your writing can add life and persuasiveness to your arguments. The key is to use quotes to support a point you’re trying to make rather than just include them to fill space.",

    "Networking is easy and fun because it taps into this human predilection to talk about ourselves when asked. Consider successful networking as little more than the process of guiding a person to tell you about his life, what he’s doing, the company that employs him, and his current industry.",
    
    "Although Botswana’s economic outlook remains strong, the devastation that AIDS has caused threatens to destroy the country’s future. In 2001, Botswana has the highest rate of HIV infection in the world. With the help of international donors it launched an ambitious national campaign that provided free antiviral drugs to anyone who needed them, and by March 2004, Botswana’s infection rate has dropped significantly.",

    "Over the centuries, the holiday evolved, and by the 18th century, gift-giving and exchanging handmade cards on Valentine’s Day had become common in England. Handmade Valentine’s cards made of lace, ribbons, and featuring cupids and hearts eventually spread to the American colonies. The tradition of Valentine’s cards did not become widespread in the United States, however, until the 1850s.",

    "“Thompson recognized and exploited all the ingredients of a successful amusement ride,” write Judith A. Adams in the American Amusement Park Industry. “His coasters combined an appearance of danger with actual safety, thrilled riders with exhilarating speed, and allowed the public to intimately experience the Industrial Revolution’s new technologies of gears, steel, and dazzling electric lights.”",

    "For centuries, Atlantis has been one of the western world’s favourite legends, a tantalizing blend of fantasy and mystery. Stories tell of a rich and glorious empire that was lost to the sea – where some hope its ruins still lie, waiting to be discovered.",

    "Just about everyone on the planet wears at least one article of clothing made from cotton at some point during the day; inevitably by-products of the plant show up as well in something that person is doing. The source of cotton’s power is its nearly terrifying versatility and the durable creature comforts it provides.",

    "Using more than fifty interviews, award-wining writer Danny Danziger creates a fascinating mosaic of the people behind New York’s magnificent Metropolitan Museum of Art – from the aristocratic, acerbic director of the museum, Philippe de Montebello, to the curators who have a deep knowledge and passionate appreciation of their collections, from the security guards to the philanthropists who keep the museum’s financial life blood flowing.",

    "Most words have experienced several changes in meaning throughout their history, so that it is impossible to say which stage in their meaning is the “true” meaning. And if we attempt to go back to “the beginning,” we find it is impossible, for the origins of many words are difficult to trace back.",

    "So, as much as this is a book about the experience of traveling – the contemplation of cities that are vast in scale and villages that are as remote and strange as anything Westerners are ever likely to encounter – it is also a book that tries to describe another kind of journey.",

    "Much of what people do today disguises a desperate search for meaning, the result of the crisis of belief that has become a major problem of the western world. On the one hand, the elites and their high culture suffer a loss of confidence, and aimless consumerism is widespread; on the other, powerful new myths arise, as with sporting heroes.",

    "Programming is the art of expressing solutions to problems so that a computer can execute those solutions. Much of the effort in programming is spent finding and refining solutions. Often, a problem is only fully understood through the process of programming a solution for it.",

    "The definition of a disaster varies by organization. Various entities have different “pain thresholds” that define when an incident becomes a disaster. A bank, for example, will have different criteria than a poison-control hotline. With this fact in mind, any organization should begin the process of implementing “first alert” and response teams after it has completed a business impact analysis.",

    "Margaret Simons explains the changes taking place in the Australian media. She analyses audiences, our major media organizations, the role of government – and the implications of all these for our society and our democracy. Her examination leads her to the conclusion that the challenges facing the content providers in the modern world are part of a broader striving, a very old struggle – we might call it the search for meaning.",

    "Today’s technological market is dominated by two contrasting business models: the generative and the non-generative models—the PCs. Windows and Macs of this world – allow third parties to build upon and share through them. The non-generative models is more restricted; appliances might work well, but the only entity that can change the way they operate is the vendor.",

    "Never has the world of journalism been so explosive, so global, and so competitive. Forget hourly news flashes; we live in a world of 24-hour breaking news with radio and TV stations and Internet sites updating stories by the minute and newspapers adjusting to stay fresh, in-depth, and relevant.",

    "Karl Marx is arguably the most famous political philosopher of all time, but he was also one of the great foreign correspondents of the nineteenth century. During his eleven years writing for the New York Tribune – their collaboration began in 1852 – Marx tackled an abundance of topics, from issues of class and the state of world affairs.",

    "Since Plato, philosophers have described the decision-making process as either rational or emotional: we carefully deliberate or we “blink” and go with our gut. But as scientists break open the mind’s black box with the latest tools of neuroscience, they’re discovering that this is not how the mind works. Our best decisions are a finely tuned blend of both feeling and reason – and the precise mix depends on the situation.",
    
    "When buying a house, for example, it’s best to let our unconscious mull over the many variables. But when we’re picking stocks and shares, intuition often leads us astray. The trick is to determine when to lean on which part of the brain, and to do this, we need think harder – and smarter—about how we think.",

    "The human animal’s status as the only clever tool-user who can talk about our feelings is crumbling. Prairie dogs can make up words for new animals. Crows are born with the ability to make tools. Elephants recognise and stroke the bones of a lost family member. As biologists delve into these subjects, they’re demonstrating that we’re not nearly as unique as we once thought. It’s the perfect time, scientifically speaking, to reassess our place in the animal kingdom.",
    
    "Market research is a vital part of the planning of any business. However experienced you or your staff may be in a particular field, if you are thinking of introducing a service to a new area, it is important to find out what the local population thinks about it first.",

    "Not a lot is known about how the transportation of goods by water first began. Large cargo boats were being used in some parts of the world up to five thousand years ago. However, sea trade became more widespread when large sailing boats travelled between ports, carrying spices, perfumes and objects made by hand.",

    "When the young artist was asked about his drawing, he explained that he had started by taking a photograph of himself sitting by a window at home. He then drew his face from the photograph and replaced the buildings which were outside the window with trees. This gave the picture a softer, more artistic background.",

    "Humans need to use energy in order to exist. So it is unsurprising that the way people have been producing energy is largely responsible for current environmental problems. Pollution comes in many forms, but those that are most concerning, because of their impact on health, result from the combustion of fuels in power stations and cars.",

    "Clearly, times are changing and while many people are saving for their retirement, many more still need to do so. Most countries have a range of pension schemes that are designed to provide individuals with an income once they stop working. People need to take advantage of these if they are to have sufficient money throughout their retirement years.",

    "According to recent research, sunshine and warm weather have a positive effect on our moods. The British Journal of Psychology has published a report in which it claims that anxiety levels fall when temperatures rise, while increased exposure to sunshine makes us think more positively about our lives.",

    "Statistics reflect vital information about the economy, the well-being of the population, and the environment. Society relies on statistics being visible, accessible and robust, and on statistically literate people making the best use of the information to determine future action. Statistical literacy, then, is the ability to accurately understand, interpret and evaluate the data that inform these issues.",

    "Housing fulfils the basic needs that people have for security, privacy and shelter. While the adequacy of housing is an important component of individual well -being, housing also has great impact on the nation's economy, with its influence on investment levels, interest rates, building activity and employment.",

    "Being physically active benefits people's health significantly, including reducing the risk of some chronic conditions, helping to control weight, and improving mental health. In recent decades, there has been a decline in physical activity because more people work in offices rather than in manual jobs.",

    "Students who wish to take a break from their studies will need to put in an application for Leave of Absence. If your application is successful, you will be notified via email. At the end of your Leave of Absence, you must re -enrol at Student Services and in the subjects you intend to study.",

    "There are a number of tests available which can suggest if a person is telling the truth, but knowing which ones are accurate is not easy. A newly created test is claimed to be the most accurate yet in lie detection. However, questions have been raised about its accuracy and ethics.",

    "A student exchange program complements formal education, while promoting tolerance, maturity and independence - all highly sought after qualities in today's competitive job market. Living in the host country, not as a tourist or guest but as a member of the community, is what makes the experience both challenging and rewarding.",

    "Tidal energy, also known as tidal power, is a renewable source of energy and a form of hydropower used to generate electricity from the energy of the tides. Though not currently widely utilised, due to high costs and limited availability, it can be called the energy resource of the future given the current rate of depletion of energy resources.",

    "Certain types of methodology are more suitable for some research projects than others. For example, the use of questionnaires and surveys is more suitable for quantitative research whereas interviews and focus groups are more often used for qualitative research purposes.",

    "Most countries are affected by labour migration. In many rural places, the traditional extended family has been undermined by the need for family members to migrate to towns as an economic necessity. Migration, therefore, presents a major challenge everywhere to social and economic policy.",

    "One of the major factors influencing future home design will be the probable change in climate, with hotter summers, colder winters, and the possibility of floods. Consequently, houses will be built with better insulation and will also need ways of keeping cool in hot weather, whether that's air conditioning or more shading of windows.",

    "Until fairly recent times, the origin of birds was one of evolution's great mysteries. This is no longer the case. Fossil evidence from China now conclusively proves that there is an evolutionary link between birds and several types of extinct prehistoric reptiles which lived millions of years ago, or in other words, dinosaurs.",

    "Group work, is valuable because of the opportunities it provides for students to develop collaboration and communication skills. As an assessment task, it has the potential to pose difficulties in relation to appropriate acknowledgement of authorship of individual group members. These difficulties can be minimised by ensuring that the task is well designed, with the roles of individuals effectively identified.",

    //"The Italian alphabet has fewer letters in comparison with the English alphabet. Italian does not use the letters J. K, W, X or Y - except in borrowed words. However, young Italians are increasingly using the letter K in words that",
    
    "Summerhill School was regarded with considerable suspicion by the educational establishment. Lessons were optional for pupils at the school, and the government of the school was carried out by a School Council, of which all the pupils and staff were members, with everyone having equal voting rights.",

    "This term the University is running a series of workshops for final year students on how to do well in interviews. These sessions will help participants prepare effectively for - and perform at their best during – later job interviews. The workshop tutors have an excellent record of success in helping students acquire the positions they desire.",

    "Tasmania is a large and relatively sparsely populated island off the south coast of Australia. The island is of particular interest to natural scientists, who go there to research the unique wildlife. Tasmania has, for example, twelve species of bird that are not found anywhere else in the world.",
    
    "Honey has traditionally been credited with significant medical powers, and it has played a major part in many folk remedies. But it seems now its efficacy is not just an old wives' tale. Recent research has shown there is scientific evidence to prove that honey contains elements that prevent bacteria from growing.",

    "The College has a fascinating museum dedicated to archaeology and anthropology. It contains information about many of the studies which have been carried out by members of the College over the five hundred years of its existence. There are many unique exhibits brought back from excavations and explorations in all the continents.",

    "History rubs shoulders and often overlaps with many other areas of research, from myths and epics to the social sciences, including economics, politics, biography, demography, and much else besides. Some histories are almost pure narratives, while others go in for detailed, tightly-focused analyses of, for example, the parish records of a Cornish village in the l61h century.",

    "There are many kinds of pond, but nearly all are small bodies of shallow, stagnant water in which plants with roots can grow. Water movement is slight and temperatures fluctuate widely. The wealth of plants ensures that during daylight hours oxygen is plentiful. However, at night, when photosynthesis no longer takes place, oxygen supplies can fall very low.",

    "Before the time of Alexander the Great, the only eastern people who could be compared with the Greeks in the fields of science and philosophy were from the Indian sub-continent. However, because so little is known about Indian chronology, it is difficult to tell how much of their science was original and how much was the result of Greek influence.",

    "While far fewer people these days write letters and therefore have Jess use for stamps, there are still a few categories of stamp which attract collectors. Stamps in common use for an indefinite period - until the price goes up - are called \"definitive\" issues, while a more collectible type of stamp is the \"commemorative\" issue, honoring people, events and anniversaries.",
    
    "In the second quarter of the 19th century, a rapidly growing middle class created a great demand for furniture production. Yet at this stage, while machines were used for certain jobs, such as carved decoration, there was no real mass production. The extra demand was met by numerous woodworkers. Mass production came later and the quality of domestic furniture declined.",

    "In the Middle Ages, the design and use of flags were considered a means of identifying social status. Flags were, therefore, the symbols not of nations, but of the nobility. The design of each flag resembled the \"devices\" on the noble's Coat of Arms, and the size of the flag was an indication of how high the owner stood in the nobility.",

    "The ritual of the state opening of parliament still illustrates the basis of the British constitution. The sovereignty of the Royal Family has passed to the sovereignty of parliament, leaving the monarchy with the trappings of power, while prime ministers are still denied the kind of status that is given to American and French presidents.",

    "Most peasants remained self-sufficient and sceptical about money - and with good reason: the triumph of capitalism probably made them worse off. They now had to deal with a centralized imperial state that was collecting tax more efficiently, giving more power to landlords, and slowly reducing customary peasant rights to land and produce.",

    "Another method governments use to try and influence the private sector is economic planning. For a long time now, socialist and communist states have used planning as an alternative to the price mechanism, organizing production and distributing their resources according to social and strategic needs, rather than based on purely economic considerations.",

    "Most succulent plants are found in regions where there is little rainfall, dry air, plenty of sunshine, porous soils and high temperatures during part of the year. These conditions have caused changes in plant structures, which have resulted in greatly increased thickness of stems, leaves and sometimes roots, enabling them to store moisture from the infrequent rains.",

    "Line engraving on metal, which, to a great extent, was a development of the goldsmith's craft of ornamenting armour and precious metals, did not emerge as a print-making technique until well into the lS1h century. Copper, the metal mainly used for engraving, was expensive, and engraving itself was laborious and took a long time.",

    "For the first two or three years after the Second World War, a new title would often sell out within a few months of publication. However, unless public demand for the book was unusually high, they were rarely able to reprint it. With paper stocks strictly rationed, they could not afford to use up precious paper or tie up their limited capital with a reprint.",

    "The Atlantic coast of the peninsula can be thought of as the cold side, and the sea on this coast tends to be clear and cold, with a variety of seaweeds growing along the rocky shoreline. On a hot day, however, this cold water can be very refreshing and is said to be Jess hospitable to sharks, which prefer warmer waters.",

    "All the works of art shown in this exhibition were purchased on a shoestring budget. The criteria that the curators had to follow were that works must be acquired cheaply, appeal to a broad range of tastes, and fit with unusual environments. Thus, many of our better known modern artists are not represented.",

    "Foam-filled furniture is very dangerous if it catches fire, and foam quickly produces a high temperature, thick smoke and poisonous gases - including carbon monoxide. Therefore, set levels of fire resistance have been established for new and second-hand upholstered furniture and other similar products.",

    "The starting point of Bergson's theory is the experience of time and motion. Time is the reality we experience most directly, but this doesn't mean that we can capture this experience mentally. The past is gone and the future is yet to come. The only reality is the present, which is real through our experience.",

    "It is important to note that saving is not the same as investment. Saving is about cash, while investment is about real product. The difference is important because money, being liquid, can leak out of the economic system - which it does when someone who is putting aside unspent income keeps it under the mattress.",

    "Historically, the low level of political autonomy of the cities in China is partly a result of the early development of the state bureaucracy. The bureaucrats played a major role in the growth of urbanization, but were also able to control its subsequent development and they never completely gave up this control.",

    "Writers may make the mistake of making all their sentences too compact. Some have made this accusation against the prose of Gibbon. An occasional loose sentence prevents the style from becoming too formal and allows the reader to relax slightly. Loose sentences are common in easy, unforced writing, but it is a fault when there are too many of them.",

    "There is a long history of rulers and governments trying to legislate on men's hair - both the length of the hair on their heads and the style of facial hair. For practical reasons, Alexander the Great insisted his soldiers be clean-shaven, but Peter the Great of Russia went further, insisting no Russians had beards.",

    "Early in the 191h century, Wordsworth opposed the coming of the steam train to the Lake District, saying it would destroy its natural character. Meanwhile, Blake denounced the \"dark satanic mills\" of the Industrial Revolution. The conservation of the natural environment, however, did not become a major theme in politics until quite recently.",

    "In the distribution of wealth, America is more unequal than most European countries. The richest tenth of the population earns nearly six times more than the poorest tenth. In Germany and France, the ratio is just over three to one. The United States also has the largest proportion of its people in long-term poverty.",

    "Chaucer was probably the first English writer to see the English nation as a unity. This is the reason for his great appeal to his contemporaries. A long war with France had produced a wave of patriotism, with people no longer seeing each other as Saxon or Norman but as English.",

    "What can history tell us about contemporary society? Generally, in the past, even in Europe until the 181h century, it was assumed that it could tell how any society should work. The past was the model for the present and the future. It represented the key to the genetic code by which each generation produced its successors and ordered their relationships.",
]
