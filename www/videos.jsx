// Tine Color: #4478B4

const Icon = ({ name, ...props }) => <i className="material-icons" {...props}>{name}</i>;

class VedioItem extends React.Component {
    increaseViews = async () => {
        await fetch(`http://ail.vic.edu.au/PTE真题音频/increaseVideoVisitCount.php?title=${this.props.title}`);
    }
    render() {
        const { title, url, views, duration } = this.props;
        const date = new Date(duration * 1000);
        const [ minutes, seconds ] = [ date.getMinutes(), date.getSeconds() ];
        const durationString = `${(minutes < 10 ? '0' : '') + minutes}:${(seconds < 10 ? '0' : '') + seconds}`;
        return (
            <div style={{ marginLeft: 8, marginRight: 8, paddingTop: 8, paddingBottom: 8, height: 80, display: 'flex', flexDirection: 'row', alignItems: 'stretch', borderBottom: '1px solid #EEEEEE' }}> 
                <div style={{ width: '35%', overflow: 'hidden' }}>
                    <video
                        style={{
                            width: '100%', height: '100%',
                            objectFit: 'cover',
                            backgroundImage: 'url(video-background.png)',
                            backgroundSize: 'cover',
                            backgroundRepeat: 'no-repeat',
                            backgroundPosition: 'center center',
                            borderRadius: 6,
                        }}
                        onPlay={this.increaseViews}
                        controls
                        preload='none'
                    >
                        <source src={url} type="video/mp4"/>
                    </video>
                </div>
                <div style={{ marginLeft: 8, maxWidth: '65%', flex: 1, display: 'flex', flexDirection: 'column', justifyContent: 'space-around' }}>
                    <p style={{ margin: 2, fontSize: 20, whiteSpace: 'nowrap', overflowX: 'auto' }}>{ title }</p>
                    <div style={{ margin: 2, marginLeft: 0, display: 'flex', flexDirection: 'row', alignItems: 'center', color: '#9E9E9E', fontSize: 13 }}>
                        <Icon name="play_arrow" style={{ fontSize: 18 }}/>
                        { views }
                        <Icon name="access_time" style={{ fontSize: 16, marginLeft: 15, marginRight: 1 }}/>
                        { durationString }
                    </div>
                </div>
            </div>
        );
    }
}

const Title = () => (
    <div style={{ display: 'flex', flexDirection: 'row', alignItems: 'center', fontSize: 16, borderBottom: '1px solid #EEEEEE', padding: 8 }}>
        <p style={{ flex: 1, margin: 0, color: '#9E9E9E' }}>PTE视频课程</p>
    </div>
);

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

function alertWithoutTitle(message) {
    const iframe = document.createElement("IFRAME");
    iframe.setAttribute("src", 'data:text/plain,');
    document.documentElement.appendChild(iframe);
    window.frames[0].window.alert(message);
    iframe.parentNode.removeChild(iframe);
}

const VideoList = ({ data }) => Object.keys(data).map(k =>
    <VedioItem key={k} title={k} {...data[k]}/>
);

const TABS = [ 'Listening', 'Speaking', 'Reading', 'Writing' ];

const Tabs = ({ selectedTab, onTabSelected }) => (
    <div style={{ display: 'flex', flexDirection: 'row', alignItems: 'stretch', position: 'fixed', top: 0, left: 0, right: 0, backgroundColor: 'white', zIndex: 100, borderBottom: '1px solid #eee' }}>
        { TABS.map(tab =>
            <div
                key={tab}
                style={{ height: '2rem', transition: 'all 0.5s', display: 'flex', flexDirection: 'row', alignItems: 'center', justifyContent: 'center', flex: 1, color: tab == selectedTab ? '#4478B4' : 'black', borderBottom: `2px solid ${tab == selectedTab ? '#4478B4' : 'transparent'}`, fontWeight: tab == selectedTab ? 'bold' : 100 }}
                onClick={() => onTabSelected(tab)}
            >
                { tab }
            </div>
        ) }
        <div></div>
    </div>
)

class Main extends React.Component {
    state = {
        data: undefined,
        vip: false,
        tab: TABS[0],
    }
    async componentDidMount() {
        try {
            const res = await fetch('http://ail.vic.edu.au/PTE真题音频/videos-data-v2.php' + (
                window.USER_ID ? `?user_id=${window.USER_ID}` : ''
            ));
            const { data, vip } = await res.json();
            console.log(vip, data);
            if (!vip) {
                alertWithoutTitle('非会员仅能查看免费视频\n请在首页左侧登陆AIL账号');
            }
            this.setState({ data, vip });
        } catch (e) {
            alert(`Error: ${e.message}`);
        }
    }
    openMembershipPage = () => {
        window.open('http://ail.vic.edu.au/pte-online-courses');
    }
    handleTabSelected = tab => this.setState({ tab })
    render() {
        if (!this.state.data) return <Loading/>;
        return (
            <div style={{paddingTop: '2rem'}}>
                <Tabs selectedTab={this.state.tab} onTabSelected={this.handleTabSelected}/>
                <VideoList data={this.state.data[this.state.tab]} />
                { !this.state.vip &&
                    <div
                        style={{
                            width: 'calc(100% - 4rem)',
                            height: 50,
                            margin: '2rem',
                            borderRadius: 6,
                            background: 'linear-gradient(to right, #2196F3, #673AB7)',
                            color: 'white',
                            display: 'flex',
                            flexDirection: 'column',
                            alignItems: 'center',
                            justifyContent: 'center',
                            fontSize: 18,
                            fontWeight: '100',
                        }}
                        onClick={this.openMembershipPage}
                    >
                        成为会员查看更多视频
                    </div>
                }
                <Footer/>
            </div>
        );
    }
}

ReactDOM.render(<Main/>, document.getElementById('root'));