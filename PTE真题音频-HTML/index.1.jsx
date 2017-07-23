// @ts-check

// Get query: ?category=...
const CATEGORY = (location.search.substr(1).split('&').find(x => x.split('=')[0] === 'category') || `category=Random`).split('=')[1];




const Icon = ({ name, ...props }) => <i className="material-icons" {...props}>{name}</i>;

const TranscriptView = ({ transcript, display }) => (
    <div style={{ borderRadius: 6, background: '#EEEEEE', overflow: 'hidden', height: display ? 180 : 1, overflowY: 'hidden', transition: 'height 0.3s' }}>
        <p style={{ margin: 6, fontSize: 14.5, fontWeight: 100 }}>{ transcript }</p>
    </div>
);

const linearTextColor = (a, b) => ({ background: `-webkit-linear-gradient(${a}, ${b})`, WebkitBackgroundClip: 'text', WebkitTextFillColor: 'transparent' });


class AudioItem extends React.Component {
    state = { expanded: false, playing: false, duration: 0, durationString: '--:--' };
    /** @type { HTMLAudioElement } */
    // @ts-ignore
    audio = new Audio(this.props.url);
    duration = 0;
    durationString = '--:--';
    constructor(props) {
        super(props);
        this.calculateDuration();
        this.audio.addEventListener('play', () => this.onAudioPlay());
        this.audio.addEventListener('pause', () => this.onAudioStop());
    }
    calculateDuration() {
        // @ts-ignore
        const date = new Date(this.props.duration * 1000);
        const [ minutes, seconds ] = [ date.getMinutes(), date.getSeconds() ];
        // @ts-ignore
        this.duration = this.props.duration;
        this.durationString = `${(minutes < 10 ? '0' : '') + minutes}:${(seconds < 10 ? '0' : '') + seconds}`;
    }
    onAudioPlay() {
        /** @type {{ category: string, title: string }} */
        // @ts-ignore
        const { category, title } = this.props;
        fetch(`http://ail.vic.edu.au/PTE真题音频/increaseAudioVisitCount.php?category=${category}&title=${title}`);
        this.setState({ playing: true });
        // @ts-ignore
        console.log(this.props.title + ' started', this.audio.currentTime);
    }
    onAudioStop() {
        this.setState({ playing: false });
        // @ts-ignore
        console.log(this.props.title + ' stopped');
    }
    reset() {
        this.audio.currentTime = 0;
    }
    async play() {
        return new Promise((resolve, reject) => {
            if (!this.state.playing) {
                const __resolve = () => { this.audio.removeEventListener('pause', __resolve); resolve(); };
                this.audio.addEventListener('pause', __resolve);
                //this.audio.currentTime = 0;
                this.audio.play();
            } else {
                resolve();
            }
        });
    }
    async stop() {
        return new Promise((resolve, reject) => {
            if (this.state.playing) {
                const __resolve = () => { this.audio.removeEventListener('pause', __resolve); resolve(); };
                this.audio.addEventListener('pause', __resolve);
                this.audio.pause();
            } else {
                resolve();
            }
        });
    }
    triggerTranscript() {
        this.setState({ expanded: !this.state.expanded });
    }
    render() {
        /** @type {{ title: string, url: string, transcript: string, views: number }} */
        // @ts-ignore
        const { title, url, transcript, views } = this.props;
        return (
            <div style={{ marginLeft: 8, marginRight: 8, display: 'flex', flexDirection: 'column', alignItems: 'stretch' }}>
                <div style={{ height: 80, display: 'flex', flexDirection: 'row', alignItems: 'center' }}>
                    <Icon name='play_circle_filled' style={{ fontSize: 50, ...linearTextColor('#68B4FF', 'black'), animation: this.state.playing ? `spin ${this.duration - this.audio.currentTime}s linear` : 'none' }} onClick={() => this.state.playing ? this.stop() : this.play()}/>
                    <div style={{ height: 60, paddingLeft: 4, paddingRight: 4, flex: 1, display: 'flex', flexDirection: 'column', justifyContent: 'center' }}>
                        <p style={{ margin: 2, fontSize: 20 }}>{ title }</p>
                        <div style={{ margin: 2, marginLeft: 0, display: 'flex', flexDirection: 'row', alignItems: 'center', color: '#9E9E9E', fontSize: 13 }}>
                            <Icon name="play_arrow" style={{ fontSize: 18 }}/>
                            { views }
                            <Icon name="access_time" style={{ fontSize: 16, marginLeft: 15, marginRight: 1 }}/>
                            { this.durationString }
                        </div>
                    </div>
                    <Icon name='arrow_drop_down' style={{ alignSelf: 'flex-end', margin: 8, fontSize: 22, transform: this.state.expanded ? 'rotate(180deg)' : 'rotate(0deg)', transition: 'transform 0.4s linear' }} onClick={() => this.triggerTranscript()}/>
                </div>
                <TranscriptView display={this.state.expanded} transcript={transcript}/>
            </div>
        );
    }
}

const Title = ({ category, isAutoPlaying, onAutoPlayButtonClick }) => {
    let title = '--';
    switch (category) {
        case 'ReadAloud': title = 'Read aloud'; break;
        case 'RepeatSentence': title = 'Repeat sentence'; break;
        case 'DescribeImage': title = 'Describe image'; break;
        case 'WriteFromDictation': title = 'Write from dictation'; break;
        case 'Random': title = '随机出题'; break;
    }
    return (
        <div style={{ display: 'flex', flexDirection: 'row', alignItems: 'center', fontSize: 16, borderBottom: '1px solid #EEEEEE', padding: 8 }}>
            <p style={{ flex: 1, margin: 0, color: '#9E9E9E' }}>{ title }</p>
            <div style={{ display: 'flex', flexDirection: 'row', alignItems: 'center' }} onClick={onAutoPlayButtonClick}>
                <p style={{ margin: 0 }}>{ isAutoPlaying ? '停止自动播放' : '自动播放' }</p>
                <Icon name={ isAutoPlaying ? 'pause_circle_outline' : 'play_circle_outline' } style={{ fontSize: 20, color: '#9E9E9E', marginLeft: 1 }}/>
            </div>
        </div>
    );
};

const Footer = () => (
    <div style={{ height: 30, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
        <p style={{ fontSize: 11, color: '#E0E0E0', margin: 0, fontWeight: 100 }}>© 2017 AUSTRALIAN INSTITUTE of LANGUAGE</p>
    </div>
);

const Loading = () => (
    <div style={{ height: window.innerHeight, display: 'flex', alignItems: 'center', justifyContent: 'center', fontWeight: 100 }}>
        <img src="loading.gif" height="40" width="40"/>
    </div>
);

const sleep = ms => new Promise(resolve => setTimeout(resolve, ms));

class Main extends React.Component {
    state = {
        data: undefined,
        category: '',
        currentAudio: '',
        autoPlaying: false
    }
    async componentDidMount() {
        const res = await fetch('data.json');
        const data = await res.json();
        const category = data[CATEGORY] ? CATEGORY : 'ReadAloud';
        console.log(data, category);
        this.setState({ data, category });
    }
    audio = new Audio()
    async startAutoPlay(list) {
        if (!this.state.autoPlaying) {
            this.setState({ autoPlaying: true }, async () => {
                const playAudio = src => new Promise(resolve => {
                    this.audio.src = src;
                    this.audio.play();
                    this.audio.onpause = () => resolve();
                });
                for (const title of Object.keys(list)) {
                    if (this.state.autoPlaying) {
                        await playAudio(list[title].url);
                    }
                    /*if (this.state.autoPlaying) {
                        // @ts-ignore
                        this.refs[title].reset();
                        // @ts-ignore
                        await this.refs[title].play();
                        await sleep(1024);
                    }*/
                }
            });
        }
    }
    async stopAutoPlay(list) {
        if (this.state.autoPlaying) {
            this.setState({ autoPlaying: false }, async () => {
                for (const title of Object.keys(list)) {
                    if (!this.state.autoPlaying) {
                        // @ts-ignore
                        await this.refs[title].stop();
                    }
                }
            });
        }
    }
    render() {
        const list = this.state.data && this.state.data[this.state.category];
        if (!list) return <Loading/>;
        return (
            <div>
                <Title category={this.state.category} isAutoPlaying={this.state.autoPlaying} onAutoPlayButtonClick={() => this.state.autoPlaying ? this.stopAutoPlay(list) : this.startAutoPlay(list)}/>
                { Object.keys(list).map((k, i) => <AudioItem ref={k} key={i} category={this.state.category} title={k} {...list[k]}/>) }
                <Footer/>
            </div>
        );
    }
}

// @ts-ignore
ReactDOM.render(<Main/>, document.getElementById('root'));