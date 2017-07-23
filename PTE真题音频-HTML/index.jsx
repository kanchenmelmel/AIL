// @ts-check
// Tine Color: #4478B4

// Get query: ?category=...
const CATEGORY = (location.search.substr(1).split('&').find(x => x.split('=')[0] === 'category') || `category=Random`).split('=')[1];
const sleep = ms => new Promise(resolve => setTimeout(resolve, ms));



const Icon = ({ name, ...props }) => <i className="material-icons" {...props}>{name}</i>;

const TranscriptView = ({ transcript, display }) => (
    <div style={{ borderRadius: 6, background: '#EEEEEE', overflow: 'hidden', height: display ? 180 : 1, overflowY: 'hidden', transition: 'height 0.3s' }}>
        <p style={{ margin: 6, fontSize: 14.5, fontWeight: 100 }}>{ transcript }</p>
    </div>
);

class AudioItem extends React.Component {
    state = { expanded: false };
    render() {
        /** @type {{ title: string, url: string, transcript: string, views: number, duration: number, onPlayButtonClick: () => any, playing: boolean }} */
        // @ts-ignore
        const { title, url, transcript, views, duration, onPlayButtonClick, playing } = this.props;
        const date = new Date(duration * 1000);
        const [ minutes, seconds ] = [ date.getMinutes(), date.getSeconds() ];
        const durationString = `${(minutes < 10 ? '0' : '') + minutes}:${(seconds < 10 ? '0' : '') + seconds}`;
        return (
            <div style={{ marginLeft: 8, marginRight: 8, display: 'flex', flexDirection: 'column', alignItems: 'stretch' }}>
                <div style={{ height: 80, display: 'flex', flexDirection: 'row', alignItems: 'center' }}>
                    <Icon name={ playing ? 'pause_circle_filled' : 'play_circle_filled' } style={{ fontSize: 50, color: '#4478B4' }} onClick={() => onPlayButtonClick()}/>
                    <div style={{ minWidth: 0, height: 60, paddingLeft: 4, paddingRight: 4, flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'stretch', justifyContent: 'center' }}>
                        <p style={{ margin: 2, fontSize: 20, whiteSpace: 'nowrap', overflowX: 'auto' }}>{ title }</p>
                        <div style={{ margin: 2, marginLeft: 0, display: 'flex', flexDirection: 'row', alignItems: 'center', color: '#9E9E9E', fontSize: 13 }}>
                            <Icon name="play_arrow" style={{ fontSize: 18 }}/>
                            { views }
                            <Icon name="access_time" style={{ fontSize: 16, marginLeft: 15, marginRight: 1 }}/>
                            { durationString }
                        </div>
                    </div>
                    <Icon name='arrow_drop_down' onClick={() => this.setState({ expanded: !this.state.expanded })}
                        style={{ alignSelf: 'flex-end', margin: 8, fontSize: 22, transform: `rotate(${this.state.expanded ? '180' : '0'}deg)`, transition: 'transform 0.4s linear' }}/>
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



class Main extends React.Component {
    state = {
        data: undefined,
        category: '',
        currentAudio: undefined,
        autoPlaying: false,
        playList: []
    };
    audio = new Audio();
    async componentDidMount() {
        //const res = await fetch('data.json');
        const res = await fetch('data.php');
        const data = await res.json();
        const category = data[CATEGORY] ? CATEGORY : 'ReadAloud';
        console.log(data, category);
        this.setState({ data: data[category], category });
    }
    async play() {
        const playAudio = title => new Promise(resolve => {
            this.audio.src = this.state.data[title].url;
            this.audio.onplay = () => this.setState({ currentAudio: title });
            this.audio.onpause = () => {
                this.setState({ currentAudio: undefined });
                resolve();
            };
            this.audio.play();
        });
        while (this.state.playList.length > 0) {
            const title = this.state.playList[0];
            fetch(`http://ail.vic.edu.au/PTE真题音频/increaseAudioVisitCount.php?category=${this.state.category}&title=${title}`).catch(console.log);
            this.state.data[title].views += 1;
            this.setState({ data: this.state.data, playing: true });
            await playAudio(this.state.playList.shift());
            await sleep(1000);
        }
    }
    pause() {
        this.audio.pause();
    }
    autoPlay() {
        if (this.state.autoPlaying) {
            this.setState({ autoPlaying: false, playList: [] }, () => this.pause());
        } else {
            this.setState({ autoPlaying: true, playList: Object.keys(this.state.data) }, () => this.play());
        }
    }
    playAudio(title) {
        if (this.state.currentAudio === title) {
            this.setState({ autoPlaying: false, playList: [] }, () => this.pause());
        } else {
            this.setState({ autoPlaying: false, playList: [ title ] }, () => this.play());
        }
    }
    render() {
        if (!this.state.data) return <Loading/>;
        return (
            <div>
                <Title category={this.state.category} isAutoPlaying={this.state.autoPlaying} onAutoPlayButtonClick={() => this.autoPlay()}/>
                { Object.keys(this.state.data).map((k, i) => (
                    <AudioItem ref={k} key={i} category={this.state.category} title={k} {...this.state.data[k]} onPlayButtonClick={() => this.playAudio(k)} playing={this.state.currentAudio === k}/>)
                ) }
                <Footer/>
            </div>
        );
    }
}

// @ts-ignore
ReactDOM.render(<Main/>, document.getElementById('root'));